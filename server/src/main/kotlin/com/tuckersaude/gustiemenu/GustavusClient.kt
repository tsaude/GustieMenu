package com.tuckersaude.gustiemenu

import io.micronaut.http.HttpRequest
import io.micronaut.http.client.RxHttpClient
import io.micronaut.http.client.annotation.Client
import io.micronaut.http.uri.UriBuilder
import io.reactivex.Maybe
import javax.inject.Singleton

@Singleton
class GustavusClient(@param:Client("https://gustavus.edu") private val httpClient: RxHttpClient) {
    internal fun fetchMenu(dateRequest: DateRequest? = null): Maybe<String> {
        val uri = UriBuilder.of("/diningservices/menu")
            .path(dateRequest?.date?.format(formatter))
            .build()
        val req = HttpRequest.GET<Any>(uri)
        val flow = httpClient.retrieve(req)
        return flow.firstElement()
    }
}