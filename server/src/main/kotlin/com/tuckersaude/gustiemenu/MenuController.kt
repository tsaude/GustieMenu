package com.tuckersaude.gustiemenu

import io.micronaut.core.convert.ConversionContext
import io.micronaut.core.convert.TypeConverter
import io.micronaut.http.annotation.Controller
import io.micronaut.http.annotation.Get
import io.micronaut.http.annotation.PathVariable
import io.reactivex.Maybe
import org.jsoup.Jsoup
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.util.*
import javax.inject.Singleton

val formatter: DateTimeFormatter = DateTimeFormatter.ofPattern("MM-dd-yyyy")

@Controller("/menu")
class MenuController(private val gustavusClient: GustavusClient) {
    @Get("/")
    fun menu(): Maybe<Menu> {
        return gustavusClient.fetchMenu().map(::toMenu)
    }

    @Get("/{date}")
    fun menu(@PathVariable date: DateRequest): Maybe<Menu> {
        return gustavusClient.fetchMenu(date).map(::toMenu)
    }
}

data class DateRequest(val date: LocalDate)

@Singleton
class DateRequestConverter : TypeConverter<String, DateRequest> {
    override fun convert(
        obj: String?,
        targetType: Class<DateRequest>?,
        context: ConversionContext?
    ): Optional<DateRequest> {
        return Optional.of(DateRequest(LocalDate.parse(obj, formatter)))
    }
}

fun toMenu(html: String): Menu {
    val dom = Jsoup.parse(html)

    val date = dom.select("#page-subtitle").text()
    val stations = dom.select(".station").map { station ->
        val name = station.selectFirst("caption").text()

        val items = station.select(".menuItem").map { item ->
            val name = item.selectFirst("a").text()
            val type = item.selectFirst(".itemMeal").text()
            val price = item.selectFirst(".itemPrice").text()
            val featured = !item.hasClass("permanentItems")

            MenuItem(name, type, price, featured)
        }

        Station(name, items)
    }.sorted()

    return Menu(stations, date)
}