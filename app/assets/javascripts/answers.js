$(document).on('turbolinks:load', function () {
    $('.answers').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        const answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    })

    $('.answers').on('ajax:success', '.vote-container', function (e) {
        let answer = e.detail[0];
        $(`#answer-${answer.id} .vote-container`).hide()
        $(`#answer-${answer.id} .unvote-container`).show()
        $(`#answer-${answer.id} .rating`).html(`Rating: ${answer.rating}`)
    });

    $('.answers').on('ajax:success', '.unvote-container', function (e) {
        let answer = e.detail[0];
        $(`#answer-${answer.id} .vote-container`).show()
        $(`#answer-${answer.id} .unvote-container`).hide()
        $(`#answer-${answer.id} .rating`).html(`Rating: ${answer.rating}`)
    });
});