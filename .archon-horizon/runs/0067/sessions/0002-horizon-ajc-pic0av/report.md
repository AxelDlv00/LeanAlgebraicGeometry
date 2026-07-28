All six commits are in the ledger and the workspace is hand-off clean. The three helpers I dispatched never returned reports, so the required fresh-context review did not happen — I'll say that plainly in the report rather than imply the work was independently audited.

## Summary

Advanced three of the four fronts of the A.3 leg with real, kernel-checked content, and corrected the roadmap where it described the remaining work wrongly. The headline: `smooth` and `proper` are no longer open obligations but assemblies over one named input each, and that "one input is the whole residue" claim is *measured* (axiom probe with a control), not argued. Sorry counts are unchanged (3/3/1) — what changed is what the sorries are.

## Progress

- `Picard/Pic0AbelianVariety.lean`: 3 sorries → 3, each strictly smaller. `smooth` = `smooth_of_geometricallyReduced` (**proved**, from mathlib's `smooth_of_grpObj`, which already contains the translation argument *and* the descent along `Spec k̄ → Spec k`) + `geometricallyReduced` (the sole residue: Cartier in char 0, `H²(C,𝒪_C)=0` in char p). `proper` = `proper_of_universallyClosed` (**proved**: `IsProper` is three fields, and this file had already proved separatedness and finite-type — they were sitting unused beside the sorry) + `universallyClosed`. `finrank_cotangentSpaceDual_eq_finrank_h1Cok` **is no longer a sorry**, proved from one named geometric input via a new sorry-free general lemma `finrank_eq_of_addEquiv_of_bijective_smul` (the `finrank` form of `rank_eq_of_equiv_equiv` — the right instrument because the two sides live over *different* rings, κ(e) and k, so `LinearEquiv.finrank_eq` and `restrictScalars` both fail).
- `Picard/IdentityComponent.lean`: 3 sorries → 3, plus new sorry-free `Pic0Scheme.inclusion`. Split the closed half out of `kPoints_iff_kerDegree`; located the real blocker of `finrank_eq_genus` — a **missing mathlib bridge** from `topologicalKrullDim` to relative dimension, not the tangent identity.
- `RiemannRoch/WeilDivisor.lean`: 1 sorry → 1, deliberately. Documented two independent obstructions the roadmap omitted.

## Issues

- **The roadmap was wrong about `AJC.rr.principal`.** It claimed the residue was "ONE input, a one-point local statement". In fact (i) the adelic endpoint is *downstream* of `WeilDivisor.lean`, so substituting it is an import inversion, and (ii) the bump route is refuted in-tree by `ChiUnconditional.not_bump_of_notMem_left`. I also recorded why that refutation is *not* fatal — its `Module.Finite` chart-section binder is a substantive restriction excluding the curves Riemann–Roch is about — so the open work is exhibiting a usable cover. Node rewritten.
- **`PicScheme.degree`: no route found I would stand behind.** Its intended construction runs through Quot, which is retained-not-revived. I did not give it a definition that merely typechecks, since `kPoints_iff_kerDegree` and the Albanese lane consume its *value*.
- **`scripts/axiom-frontier.lean` consumes the false leaf** that protection I-0491 orders deleted (`:358`, `:433`). Flagged to ajc-etale-pic rather than touching their files; the project's own axiom instrument will stop compiling when the leaf goes.
- **The three subagents I dispatched (work-reviewer, janitor, degree-map scout) never returned reports** — their transcripts went quiet at stub size. So the required fresh-context review of this diff did **not** happen. My claims rest on my own kernel build and axiom probe, not on independent audit.

## Why I stopped

Partly advanced, not complete — so I set no terminal status and the task returns to the queue. Three of four fronts moved; none of the four closed. Two are blocked on things I could not honestly resolve (the degree map, and the missing Krull-dimension bridge), and the tangent lane's residue is now a single geometric statement that is genuine multi-session work. Everything is committed (six commits) and `lake build` of all three edited modules completes successfully with zero errors.

## Next

1. `geometricallyReduced` and `universallyClosed` are now the two cheapest real wins in this lane — each is one theorem, with sources and the circularity trap documented at the site.
2. For the tangent lane, the residue needs no Hilbert 90 and no henselian machinery (confirmed from the AJCR side): the thickening is square-zero, so `Algebra.FormallyEtale.comp_bijective` covers it.
3. `finrank_eq_genus` needs the Kähler-differentials rank bridge, or consumers should retarget to `SmoothOfRelativeDimension (genus C)`.
4. Someone should re-run the fresh-context review that did not land here.
