$(document).on('turbolinks:load', function (){
    $('.question').on('click', '.edit-question-link', function (e) {
        e.preventDefault();
        $(this).hide();
        const questionId = $(this).data('questionId');
        $('form#edit-question-' + questionId).removeClass('hidden');
    })

    $('.question').on('ajax:success', '.vote-container', function (e) {
        let question = e.detail[0];
        $(`#question-${question.id} .vote-container`).hide()
        $(`#question-${question.id} .unvote-container`).show()
        $(`#question-${question.id} .rating`).html(`Rating: ${question.rating}`)
    });

    $('.question').on('ajax:success', '.unvote-container', function (e) {
        let question = e.detail[0];
        $(`#question-${question.id} .vote-container`).show()
        $(`#question-${question.id} .unvote-container`).hide()
        $(`#question-${question.id} .rating`).html(`Rating: ${question.rating}`)
    });
});