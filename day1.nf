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
    PART1(ch_input.left, ch_input.right).view { "Part 1: ${it}" }
    PART2(ch_input.left, ch_input.right).view { "Part 2: ${it}" }
}
workflow PART1 {
    take:
    ch_left
    ch_right

    main:
    // Could've used reduce instead of sum
    ch_total_distance = ch_left
        .toSortedList()
        .flatten()
        .merge(ch_right.toSortedList().flatten())
        .map { left, right ->
            (left - right).abs()
        }
        .sum()

    emit:
    total_distance = ch_total_distance
}

workflow PART2 {
    take:
    ch_left
    ch_right

    main:

    ch_frequencies = ch_right.toSortedList().countBy { it }

    ch_similarity_score = CALCULATE(ch_left, ch_frequencies).sum()

    emit:
    similarity_score = ch_similarity_score
}

process CALCULATE {
    input:
    val left
    val frequencies_map

    output:
    val answer

    exec:
    if (frequencies_map[left] != null) {
        // println("${left} appears in the right list, so the similarity score increases")
        answer = left * frequencies_map[left]
    }
    else if (frequencies_map[left] == null) {
        // println("${left} does not appear in the right list, so the similarity score does not increase")
        answer = 0
    }
    else {
        error("Something isn't right")
    }
}
