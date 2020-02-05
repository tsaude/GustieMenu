package com.tuckersaude.gustiemenu

data class Menu(
    val stations: List<Station>,
    val date: String
)

data class Station(
    val name: String,
    val menuItems: List<MenuItem>
): Comparable<Station> {
    override fun compareTo(other: Station): Int = if (menuItems.any { it.featured } && other.menuItems.all { !it.featured }) {
        -1
    } else {
        1
    }
}

data class MenuItem(
    val name: String,
    val type: String,
    val price: String,
    val featured: Boolean
)