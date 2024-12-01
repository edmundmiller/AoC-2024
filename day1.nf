params.input = "${projectDir}/assets/day1.txt"
workflow {
    // Why give me a file split by 3 spaces?
    ch_input = channel
        .fromPath(params.input)
        .splitCsv(
            sep: " ",
            strip: true
        )
        .map { it ->
            [it[0].toInteger(), it[3].toInteger()]
        }
        .multiMap { v ->
            left: v[0]
            right: v[1]
        }

    ch_input.left
        .toSortedList()
        .flatten()
        .merge(ch_input.right.toSortedList().flatten())
        .map { left, right ->
            (left - right).abs()
        }
        .sum()
        .view()
}
