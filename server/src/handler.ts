import { Handler, APIGatewayProxyResult, APIGatewayProxyEvent } from "aws-lambda";
import { getMenu, MenuRequest } from "./integrations/gustavus-menu";

const menu: Handler<APIGatewayProxyEvent, APIGatewayProxyResult> = async (event, context) => {
    console.info(JSON.stringify(event))
    console.info(JSON.stringify(context))

    return {
        statusCode: 200,
        body: JSON.stringify(await getMenu(toRequest(event)))
    }
}

function toRequest(event: APIGatewayProxyEvent): MenuRequest | undefined {
    let request: MenuRequest | undefined = undefined

    if (event.pathParameters != null && event.pathParameters.date != null) {
        try {
            request = new MenuRequest(event.pathParameters.date)
        } catch(e) {
            console.warn(`Invalid date passed to ${event.path} - ${event.pathParameters}`)
        }
    }

    return request
}

export { menu }