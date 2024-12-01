// TODO Use real data
params.input = "${projectDir}/assets/day1_example.txt"
workflow {
    ch_input = channel
        .fromPath(params.input)
        .splitText { line -> line.split('   ') }
        .multiMap { v ->
            left: v[0]
            right: v[1]
        }

    ch_input.left.view { v -> "foo ${v}" }
    ch_input.right.view { v -> "bar ${v}" }

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
        .sum()
        .view()
}
