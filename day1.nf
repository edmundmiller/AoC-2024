workflow {

    def distances = [
        2,
        1,
        0,
        1,
        2,
        5,
        11
    ]
    def total_distance = 11
    ch_list1 = channel
        .of(
            3,
            4,
            2,
            1,
            3,
            3
        )
        .toSortedList()
        .flatten()
    ch_list2 = channel
        .of(
            4,
            3,
            5,
            3,
            9,
            3
        )
        .toSortedList()
        .flatten()

    matched_list = ch_list1
        .merge(ch_list2)
        .map { left, right ->
            (left - right).abs()
        }
        .view()
}
