# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#$ ->
#	$('#Remove_Ans').click = ()-> 
#		$('.offset1.fields input').attr('value', 1);
#		$('.offset1.fields').hide();
#		$(link).previous("input[type=hidden]").value = 1;
#		$(link).up(".fields").hide;
#		$(this).parent("input").attr('value', " ");
#		$(this).parent().parent().slideUp();

$(document).on 'ready page:load', ->
	voteCount = []
	topCount = [0,0,0,0,0]
	check = false
	$('#SubmitButton').attr('disabled', true);
	
	$('#SubmitButton').hide();
	$('#QErrorMessage').hide();
	$('#AErrorMessage').hide();
	$('.Add_Ans').hide();
		
	$('.Polls').each (index, element) ->
		$(this).hide();
		voteCount.push 0;
		
	
	## Handled in controller instead	
	#$('.Votes').each (index, element) ->
	#$(this).hide();
	#voteCount[$(this).text()-1] = voteCount[$(this).text()] + 1;
	#$('.Popular').each (index, element) ->
	#	$(this).parent().hide();
	#	check = false
	#	for num in topCount
	#		if voteCount[index] > num
	#			$(this).parent().show();
	#			check = true
	#			topCount[num] = voteCount[index]
		
	$('.Remove_Ans').on 'click', -> 
		$(this).parent().children(':nth-child(3)').attr('value', ' '); 
		$(this).parent().children().hide(); 
		$(this).parent().children(':nth-child(6)').show();
		
	$('.Add_Ans').on 'click', ->
		$(this).parent().children(':nth-child(3)').attr('value', ''); 
		$(this).parent().children().show();
		$(this).parent().children(':nth-child(6)').hide();

	$('#Question').on 'change', ->
		questlen = ($(this).val()); 
		if questlen.length >= 5
			Total = 0;
			$('.AnsField').each (index, element) ->
				AnsVal = $(this).val();
				if $.trim(AnsVal).length == 0
					Total = Total + 1;
				if Total < 4
					$('#SubmitButton').show();
					$('#SubmitButton').removeAttr('disabled');					
					$('#FakeButton').hide();
				else
					$('#SubmitButton').hide();
					$('#SubmitButton').attr('disabled', true);
					$('#FakeButton').show();
					$('#FakeButton').on 'click', -> 
						$('#AErrorMessage').show();
		else  
			$('#SubmitButton').hide(); 
			$('#FakeButton').show();
	
	
	$('.AnsField').on 'change', ->
		questlen = ($('#Question').val()); 
		if questlen.length >= 5
			Total = 0;
			$('.AnsField').each (index, element) ->
				AnsVal = $(this).val();
				if $.trim(AnsVal).length == 0
					Total = Total + 1;
				if Total < 4
					$('#SubmitButton').show(); 
					$('#SubmitButton').removeAttr('disabled');
					$('#FakeButton').hide();
				else
					$('#SubmitButton').hide();
					$('#SubmitButton').attr('disabled', true);
					$('#FakeButton').show();
					$('#FakeButton').on 'click', -> 
						$('#AErrorMessage').show();
		else  
			$('#SubmitButton').hide(); 
			$('#FakeButton').show();
		
	
	
	$('#FakeButton').on 'click', ->
		Total = 0;
		$('.AnsField').each (index, element) ->
			AnsVal = $(this).val();
			if $.trim(AnsVal).length == 0
				Total = Total + 1;
			if Total >= 4
				$('#AErrorMessage').show();
		QuestVal = ($('#Question').val());
		if QuestVal.length < 5
			$('#QErrorMessage').show();
	
	
	
	# FOR SORT ON INDEX
	$('.PollList').hide();
	$('#DefaultPolls').show();
	
	$('#AgeButton').on 'click', ->
		$('.PollList').hide();
		$('#Age').show();
		
	$('#OldAgeButton').on 'click', ->
		$('.PollList').hide();
		$('#OldAge').show();
		
	$('#AlphaButton').on 'click', ->
		$('.PollList').hide();
		$('#Alphabetical').show();
		
	$('#CreatorButton').on 'click', ->
		$('.PollList').hide();
		$('#Creator').show();
		
	$('#PopularityButton').on 'click', ->
		$('.PollList').hide();
		$('#Popularity').show();

	