Waiting on the review verdict. Everything else is settled.

Final verification state, stated precisely because the mutex forced a substitution:

- **All five files kernel-clean** — `lake env lean` on each, exit 0, the single declared `sorry` at `Pic0ChartLocusIsOpen.lean:146` the only warning.
- **Root closure not re-verified for my last four commits.** My earlier full root build went green (9142 jobs, exit 0) but predates them. Two attempts at a final root build both died on my own lock guard — the AJCR mutex was held for ~35 minutes straight, with no pidfile for the first 25 of those, so the protocol's reap branches were unreachable and waiting was the only correct move. I did not reap it. That gap is real and will be in the report, not smoothed over.

The mutex starvation is now filed as an issue to the human and recorded as memory, including the fix-side clue: some live acquirer takes the lock without the documented recipe that writes the pidfile, so the no-pidfile window isn't merely best-effort drift.
