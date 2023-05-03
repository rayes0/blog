---
title: "Statistical Analysis of the Lee-Lin Rivalry"
author: ["rayes"]
tags: ["badminton", "R"]
categories: ["Statistics"]
draft: true
---

Anyone who is even remotely involved in competitive badminton anytime in the last couple years has no doubt heard about the two greats [Lin Dan](https://en.wikipedia.org/wiki/Lin_Dan) and [Lee Chong Wei](https://en.wikipedia.org/wiki/Lee_Chong_Wei), and their [decade-long rivalry](https://en.wikipedia.org/wiki/Lee%E2%80%93Lin_rivalry). Here, I create a dataset gathered from information about every single one of the 40 tournament matches they played against each other, and attempt to uncover interesting correlations.


# Initial Musings {#initial-musings}

Without getting into the data, there are some general details about the rivalry worth noting. I will assume at least basic familiarity with the scoring system used in competitive badminton and the general rules.

Firstly, the two played each other in an official BWF tournament (not a show match or anything) a total of 40 times throughout their careers. Out of these 40, Lin won 28 times, whereas Lee only won 12. Thus, you may be quick to say that Lin was the obvious better player out of the two. This is not necessarily the case. In their 40 matches, a good proportion of them went to three games, and a lot of the scores were close. Lee also has better statistics outside of their rivalry, with a better career win-loss ratio, and was ranked higher than Lin for the majority of the time they were active. Lin did hold more titles though, owing to his better performances in various finals. Thus, I do agree with the fact that Lin is a mentally stronger player.

It is also worth mentioning that the players played four games before the scoring system change in 2006 from the 15 point system where you could only score while you have the serve to the 21 rally-point system. The change sparked a new approach to playing. In the 15 point system, consistency and scoring streaks of points was handsomely rewarded, whereas scoring points inconsistently was heavily punished. For every rally you lose you needed to make up two rallies to get it back (and possibly three, if your opponent was the server). In the 21 point system, anyone can get a point anytime, meaning that mistakes are punished with less severity. It encourages a more aggressive play style, yearning towards shots which have a higher chance of winning the rally but are riskier to execute.


# The Data Dictionary {#the-data-dictionary}

I scraped all the data from BWF that I could. However, because much of the data I am interested in is in the games themselves, I manually added other data from watching every single point in each of the 40 games. The data was recorded in a CSV file, with each row representing one game (one _game_, not one match[^fn:1]).

This section contains the data that was acquired from scraping:

-   `match` - identifier for the match this game is a part of. An integer from 1 to 40.
-   `series` - identifier for the series the tournament for this game is classified as. Eg: "Super Series"
-   `year` - the year this game was played. Eg: "2011"
-   `round` - the round this **match** is from in the current tournament. Note: _match_, not game. This can be either "final", "semi-final", "quarter-final", "last-16", or "group"
-   `game-num` - The game number in this current match. Either "1", "2", or "3".
-   `winner` - The winner of this game. Either "Lin" or "Lee".
-   `winner-score` - The score of the winner of this game. Will be "21" for most cases, but will be greater if the game went to deuce.
-   `loser-score` - The score of the loser of this game.

Here is the other data I manually entered from watching the games:

-   Rally data:
    -   `lin-easy-mistakes` - The number of points lost given away by Lin due to easy mistakes. An easy mistake is defined as:
        -   Missing a serve, or getting a service fault
        -   Hitting a shot way out of bounds or into the net, and the player was not under pressure. General common sense was used when classifying whether the player was "under pressure" or not. Points that get added here mean that the player was in a stable position to return the shot, but didn't due to careless error. As a badminton player myself, I have an intuition on what shots should be easy to return and which are not in a rally.
        -   Touching the net, contacting on the other side, or any other foul that easily gives the opponent the point
        -   Getting a red card (I don't think there are any cases of this in any of the Lee-Lin matches though)
    -   `lee-easy-mistakes` - same thing as `lin-easy-misakes` but for Lee.
    -   `lin-line-shot-mistakes` - Shots which the loser hit that were close to being in, but were out by a small margin, anything less than about 10cm for the side lines, and 30cm for the back line (again, general common sense is used here). In this range, it is difficult to tell for either players whether the shot is going to be in or out. The back line is given a more generous margin because it is harder to judge long shots that land near the line. One telltale sign a shot belongs in this category is whether the receiver is hesitant whether to return the shot or not because they don't know whether it is going to be in or out. Shots where either player calls for use of the hawkeye do not count, unless the margin is very large and it is obvious where the shot landed.
    -   `lee-line-shot-mistakes` - same thing as `lin-line-shot-mistakes` but for Lee.
    -   `lin-smash-wins` - number of rallies Lin won with a smash, **preceded by a couple of well-executed setup shots**.
    -   `lee-smash-wins` - same thing as `lin-smash-wins` but for Lee
    -   `lin-lucky-wins` - number of rallies Lin won with a smash **without using a setup**.
    -   `lee-lucky-wins` - same thing as `lin-lucky-wins` but for Lee
    -   `lin-pressured-wins` - number of rallies where Lin won due to pressuring Lee until he misses, and the winning shot is not a smash (if it is a smash, classify it as a smash-win)
    -   `lee-pressured-wins` - same thing as `lin-pressured-wins` but for Lee.
    -   `lin-net-kill-wins` - number of rallies where Lin won due to a net kill
    -   `lee-net-kill-wins` - same thing as `lin-net-kills` but for Lee
    -   `lin-deception-wins` - number of rallies where Lin won due to a deceptive shot
    -   `lee-deception-wins` - same thing as `lin-deception-wins` but for Lee.
    -   `lin-net-roll-wins` - number of rallies won by Lin due to a net roll
    -   `lee-net-roll-wins` - number of rallies won by Lee due to a net roll

Every rally must fall under one (and only one) of the following categories: "easy-mistakes", "line-shot-mistakes", "smash-wins", "lucky-wins", "pressured-wins", "net-kill-wins", "deception-wins", or "net-roll-wins".

-   `lin-shuttle-change` - number of times Lin requests a shuttle change during this game
-   `lee-shuttle-change` - same as `lin-shuttle-change` but for Lee
-   `lin-consecutive-points` - max number of consecutive points taken by Lin
-   `lee-consecutive-points` - same as `lin-consecutive-points` but for Lee
-   `interval-lead` - who has the lead at the interval. Either "Lin" or "Lee"
-   `has-coach` - whether the player has a coach present that gives them advice at the interval. Boolean value.
-   `coin-flip-winner` - the winner of the coin flip at the beginning of the match. Because each match only has one coin flip, this will be the same for consecutive matches. Either "Lin" or "Lee"

[^fn:1]: For those who for some reason are reading do not know the scoring system in badminton, one _match_ between two players consists of a best of three _games_ played to 21 points. If a player wins the first game and the second game, they win the match. Otherwise, if one player wins first game and the other wins the second, they play a third as a tiebreaker.