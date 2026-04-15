# Session handoff

## When to use

- Ending a long session, switching machines, or handing work to another person or agent.
- Context is large and the next session should start without re-discovery.

## Steps

1. Write the **goal** in one line and whether it is blocked, in progress, or done.
2. List **facts**: branch name, commands that reproduce success, failing test names or error snippets.
3. List **decisions already made** (libraries, approach) so they are not re-litigated.
4. List **open questions** that still need a human or external input.
5. Point to **files that matter** (paths only), not entire transcripts.
6. If there is a partial implementation, say exactly what is left and the next smallest step.
7. Avoid pasting secrets; reference env var names and where to load them from.
8. Prefer a short `HANDOFF.md` or ticket comment over dumping raw chat logs.
