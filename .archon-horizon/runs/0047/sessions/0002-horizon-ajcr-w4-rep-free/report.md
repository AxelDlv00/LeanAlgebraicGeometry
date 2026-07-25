I have three background jobs pending (the confirmation build, the janitor, and the reviewer) and shouldn't start new Lean work I can't verify before they land. Let me summarize where things stand.

**What I found and changed**

The representability lane had been stuck for ~7 sessions on a hypothesis it never needed. The DD-R certificate assembler demanded a *global* certificate `IsCertified g` over the carve chart ring, whose no-leak input is genuinely false for refined pieces (recorded as memory I-0209, and read for months as "the lane is blocked"). But every downstream consumer goes through `DivFamZar`, whose predicate is the *Zariski-local* `IsLocallyCertified` — a span-⊤ family of base localizations each carrying an ordinary certificate. The impossibility ruled out one spelling of the goal, not the goal.

The distinction that matters: localizing the **pieces** destroys finiteness (I-0209 is right about that), but localizing the **base** keeps the divisor scheme finite over it, and that is exactly what the consumer predicate is built from.

**Landed, all kernel-checked** (`lake env lean`, warning-free, axioms only `propext`/`Classical.choice`/`Quot.sound`):

- the span-⊤ production rule for `IsLocallyCertified`, and a **pointwise** gate via quasi-compactness of `Spec R` — an away-certificate at each prime suffices;
- an adaptation-free form (the adaptation is free by extraction, so only the certificate over the shrunken base remains);
- the support tube refined to `Away`-chart form, plus the no-leak clause derived from support containment — so the previously false hypothesis becomes true over the tube;
- the invented spanning submodule eliminated from both assemblers;
- the F5 forward map weakened to take a `DivFamZar` class, with agreement to the old map by `rfl` — proving the certificate argument it demanded was definitionally unused. Without this the forward direction would have re-imposed the gate I'd just removed.

Two audits worth flagging: `DivRepGlobalData.representableBy` already delivers the `divRep` endpoint from clauses stated purely on `divFamZar`, and `DivFamZar.exists_certChartCover` already extracts away-local certified representatives — so the away-local shape is this lane's own currency, not a workaround.

**Roadmap**: the opaque certificate blocker is now four leaves — `zar-gate` done, and `tube-fibre` / `away-kerspan` / `away-assemble` pending, each reduced to a named fibrewise fact. The degree input was already proved last session.

**Honest caveats**: the two remaining certificate obligations are real geometry, not packaging — and the syzygy file proves the kernel-spanning one is *equivalent* to the flatness being sought, so no cleverer submodule choice will evade it. The objective is not complete. A confirmation `lake build` of the kerspan module and two review agents are still running; I'll fold in their results when they land.
