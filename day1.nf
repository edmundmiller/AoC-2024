params.input = "${projectDir}/assets/day1_example.txt"

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
    PART1(ch_input.left, ch_input.right)
    PART2(ch_input.left, ch_input.right)
}
workflow PART1 {
    take:
    ch_left
    ch_right

    main:
    // Could've used reduce instead of sum
    ch_left
        .toSortedList()
        .flatten()
        .merge(ch_right.toSortedList().flatten())
        .map { left, right ->
            (left - right).abs()
        }
        .sum()
        .view { "Day 1: ${it}" }
}

workflow PART2 {
    take:
    ch_left
    ch_right

    main:

    def frequencies = ch_right.toSortedList().countBy { it }.view()

    emit:
    ch_left
}
