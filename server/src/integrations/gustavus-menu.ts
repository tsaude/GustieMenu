import axios from 'axios'
import * as cheerio from 'cheerio'

const url = "https://gustavus.edu/diningservices/menu"

interface GustavusMenu {
    stations: Station[],
    date: string
}

interface Station {
    name: string
    menuItems: MenuItem[]
}

interface MenuItem {
    name: string
    type: string
    price: string
    featured: boolean
}

export class MenuRequest {
    date: string

    constructor(date: string) {
        if (date.match(/^\d\d-\d\d-\d\d\d\d$/)) {
            this.date = date
        } else {
            throw new Error("Date is in the wrong format.  Must be MM-dd-yyyy.")
        }
    }
}

export async function getMenu(req?: MenuRequest): Promise<GustavusMenu> {
    let finalUrl: string
    if (req) {
        finalUrl = `${url}/${req.date}`
    } else {
        finalUrl = url
    }

    let html = (await axios.get(finalUrl)).data

    return parseHTML(html)
}

function parseHTML(html: string): GustavusMenu {
    let $ = cheerio.load(html)

    const parseMenuItem = (_: number, element: CheerioElement): MenuItem => {
        let item = $(element)

        let name = item.find('a').text()
        let type = item.find('.itemMeal').text()
        let price = item.find('.itemPrice').text()
        let featured = !item.hasClass('permanentItems')

        return { name, type, price, featured }
    }

    const parseStation = (_: number, element: CheerioElement): Station => {
        let station = $(element)

        let name = station.find('caption').text()
        let menuItems = station.find('.menuItem').map(parseMenuItem).get() as MenuItem[]

        return { name, menuItems }
    }

    let stations = $('.station').map(parseStation).get() as Station[]
    let date = $('#page-subtitle').text()

    return {
        date,
        stations
    }
}
