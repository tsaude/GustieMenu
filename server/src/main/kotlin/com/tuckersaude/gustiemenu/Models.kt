package com.tuckersaude.gustiemenu

data class Menu(
    val stations: List<Station>,
    val date: String
)

data class Station(
    val name: String,
    val menuItems: List<MenuItem>
)

data class MenuItem(
    val name: String,
    val type: String,
    val price: String,
    val featured: Boolean
)