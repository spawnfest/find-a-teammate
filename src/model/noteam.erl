%%% This model is being used for people who signed up to the event itself,
%%% but did not decide on a team yet.  They might have looked through the list
%%% of currently available teams and they did not find anything they liked.
%%% 
%%% We store the currently available teams per email address and when new
%%% teams are being formed, an event handler will go through the list of
%%% people and send the newly created team to the people in the list.
%%% Furthermore, the team list for the people will be updated too, so that only
%%% new teams are being reported.
-module(noteam, [Id, Email, TeamsSoFar]).
-compile(export_all).

