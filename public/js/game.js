var STATUS = {}
var VALID_COMMANDS = {
  "ExploringState": ["north", "south", "east", "west", "up", "down",
      "magic", "run", "fight", "tally", "consume", "pick_up"],
  "FightingState": ["1", "2"],
};
var greetingsMessage =  {greetings: "Welcome hero! You are about to start an adventure.\n In order to start the adventure you must move through the castle\n you must type: north, south, east, west, up, down, magic, run, fight,\n tally, consume, pick_up. \n If you want to remember this instructions type <help>. \n\n Let's get started! \n Are you ready for this adventure? \n Type <start> to begin!"};


var CURRENT_STATE = "ExploringState";

var werewolf = {};

werewolf.init = function() {
	$('#shell').terminal(werewolf.terminal.main, greetingsMessage);
};

function getStatus(callback){
	$.ajax({
		type: 'GET',
		url: '/status',
		data: {},
		success: function(data, textStatus, jqXHR) {
			try { data = JSON.parse(data); } catch (e) { alert("ERROR parsin JSON"); }
				if (data) {
					STATUS = data;
					CURRENT_STATE = data.state;
				}
				callback(STATUS);
		}

	});
}


function validCommand(command){
	var isValid = VALID_COMMANDS[CURRENT_STATE].indexOf(command) >= 0;
	// if (command == "fight" && !hasMonster()) valid = false;
	return isValid;
}


werewolf.terminal = {
	main: function(input, terminal) {
		getStatus(function (status){
			terminal.echo(status.output);
		});

		var command = $.trim(input);
		if (command !== '') {
			var argv = command.split(' ');
			if (!validCommand(argv[0])){
				terminal.echo("Invalid command type <help> if you need to remember available commands")
				return;
			}
			$.ajax({
				type: 'POST',
				url: '/command',
				data: { command: argv[0] },
				success: function(data, textStatus, jqXHR) {
					console.log("RESPONSE:", data);
					try { data = JSON.parse(data); } catch (e) { alert("ERROR parsin JSON"); }
						if (data) {
							STATUS = data;
							CURRENT_STATE = data.state;
						}
						terminal.clear();
						terminal.echo(data.output);
				}

			});


		}

		// blank line trailer
		werewolf.terminal.write('\n', terminal);
		werewolf.terminal.scroll();
	},

	write: function(string, terminal) {
		// write a string to the terminal, breaking long strings on word boundaries.

		if (string.length <= terminal.cols()) {
			terminal.echo(string);
		} else {
			var words = string.split(' ');

			var shortString = "";
			for (var i=0; i < words.length; i++) {
				var currentWord = words[i];
				if (shortString.length + 1 + currentWord.length > terminal.cols()) {
					// we can't add any more to this line without overflowing.

					// check for stupidly long words, and break them with hyphenation
					if (currentWord.length > terminal.cols()) {
						var charsRemaining = terminal.cols() - shortString.length;

						if (shortString === '') {
							shortString = currentWord.substring(0, charsRemaining - 1) + '-';

							// save remaining characters of this long word
							words[i] = currentWord.substring(charsRemaining - 1);
						} else {
							shortString += ' ' + currentWord.substring(0, charsRemaining - 2) + '-';
							// save remaining characters of this long word
							words[i] = currentWord.substring(charsRemaining - 2);

						}

					}

					// write the truncated string, then recurse on the remainder
					terminal.echo(shortString);
					return werewolf.terminal.write(words.slice(i).join(' '), terminal);
				} else {
					if (shortString === '') {
						shortString = words[i];
					} else {
						shortString += ' ' + words[i];
					}
				}
			}
		}
	},

	scroll: function() {
		var bottom = $('#shell').offset().top + $('#shell').height();
		window.scrollBy(0, bottom);
	}
};


werewolf.configuration = {greetings: "Test"};

$(function() {
	werewolf.init();
});
