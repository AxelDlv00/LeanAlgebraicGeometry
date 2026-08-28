All my authored changes are now committed. The remaining working-tree entries belong to other live lanes.

## Summary

I did not close flat base change, but I established that its priority obligation was **mis-scoped rather than hard**, proved the statement its consumers actually need, and measured the result against a control that still leaks. Two of my own claims were then refuted by independent review, and both fixes landed.

## Progress

- `Cohomology/CechHigherDirectImageUnconditional.lean`: **3 sorries → 3 sorries, +15 sorry-free declarations.** The line-682 obligation (flat `g^*` preserves monos of *arbitrary* modules) is genuinely walled — mathlib gives `SheafOfModules.pullback` no pointwise model, and a sibling project independently hit the same brick for `j_!`. But no consumer needs it. Two reductions closed the gap: **cone-cancellation** (`F` preserves `lim K`, `F ⋙ G` preserves `lim K` ⟹ `G` preserves `lim (K ⋙ F)`) converts the tree's existing "the composite `(~) ⋙ g^*` is exact" into exactness on tilde-shaped diagrams — the previous session read that composite as "only on the tilde image" and stopped; and **`tilde` is full**, so a map of quasi-coherent modules *is* `tilde.map` of a module map. Since `ShortComplex.mapHomologyIso` needs one kernel per degree rather than global exactness, this yields `pullback_preservesKernel_of_isQuasicoherent`, `pullback_mapHC_homologyIso_of_isQuasicoherent`, and `cech_flatBaseChange_of_termsQuasicoherent` — which removes the leaf from flat base change's proof term.
- `scripts/axiom-frontier.lean`: three probes plus a non-vacuity witness report clean beside `leakControl_qcohRoute_oldRoute`, which reaches the *same conclusion* by the old route and still reports `sorryAx`. 157/53 → 162/54.
- Blueprint + hgraph: 4 nodes and 7 edges, so `graph frontier` no longer presents the walled route as this lane's live target. `\leanok` marks verified three ways.
- `TO_USER.md`: corrected a **false claim about my own lane** — it told users `pullback_preservesFiniteLimits` "was proved"; it was only de-instanced and still reports `sorryAx`.

## Issues

Two of my claims were wrong and were caught by others. I recorded "closure of quasi-coherence under finite products" as a missing blocker in three places; it was false over an affine base and provable from my own hour-old lemma — now `isQuasicoherent_pi_of_isAffineBase`. And my non-vacuity witness *assumed* the flatness binder it claimed to witness. Separately, four `roadmap set --strategy` writes were silently dropped (the flag is `--summary`), which I learned only from a janitor pass — I had been filtering CLI output through `tail -1` and losing the errors.

## Why I stopped

**Partly advanced, not complete.** The two cosimplicial naturality squares are untouched, and I verified they are *not* mis-scoped: `Pi.hom_ext` — the tool that closed this project's two existing naturality squares — cannot fire, because the σ-decomposition is buried mid-chain behind pushforward/pullback applications. They need per-σ projection lemmas nobody has built. I restored the file byte-identical after probing. Flat base change remains unproved, now with **one** leak source instead of two. No terminal status set. Root build green at 8773 jobs; 28 sorry carriers unchanged (21 theorem + 7 def + 0 instance).

## Next

Discharge `h₂`/`h₃` of `cech_flatBaseChange_of_termsQuasicoherent` — now bookkeeping rather than mathematics: match the two `(CechComplex f 𝒰 F).sc i` terms to the σ-product through `pushPull_sigma_iso`. Every input exists. Then the naturality squares, as one obligation with two instances.
