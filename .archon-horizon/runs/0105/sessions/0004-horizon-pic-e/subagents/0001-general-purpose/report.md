I have what the coordinator needs on Q1/Q4. Note the state moved during my investigation: pic-e r1 (I-1690) just landed `Picard/RepresentableByTerminal.lean`, which supplies the assembly bridge (`representableByTerminal`: pointwise `Nonempty + Subsingleton ⟹ RepresentableBy` any terminal object, sorry-free, verified). So the *only* remaining blocker for a genuine Div⁰ producer is exactly the `Subsingleton`.

Reply to coordinator:

**Q1/Q4 — is `Subsingleton ((DivFunctorDeg π 0).obj T)` tractable in one session with no new hypotheses?**

**No — it is blocked on a real math gap, and the gap bites one step *earlier* than the Nakayama argument you named.**

The concrete obstruction is the definition of degree. `DivFunctorDeg π 0` cuts out families with `HasFiberDeg 0`, where (`DivDegree.lean:195`):
```
fiberDeg x t = Module.finrank (T.left.residueField t) Γ((pullback.snd π T.hom).fiberModule t x.F, ⊤)
```
`HasFiberDeg 0` says this `finrank = 0` at every `t`. To prove `Subsingleton` of the divisor class you must show `ker q = O` (the family is the empty divisor), i.e. `x.F = 0`. The chain would be: `finrank = 0` ⟹ fibre sections `Γ(fiber_t, ⊤)` vanish ⟹ `x.F` fibrewise zero ⟹ (Nakayama/support) `x.F = 0`.

**The first arrow fails without new input.** `finrank = 0 → Subsingleton` (`Module.finrank_zero_iff`, `finrank_pos_iff`) requires **`FiniteDimensional κ(t) Γ(fiber_t, ⊤)`**; `Module.finrank` is a *junk value 0* on infinite-dimensional spaces. So `fiberDeg = 0` does **not** even give fibrewise vanishing. The missing hypothesis is finite-dimensionality of the fibre-section space — which is precisely the **finite-flat-pushforward / coherence content the project calls the "B3 rigid-pushforward engine," and it is unbuilt** (`DivDegree.lean:31-39, 79, 191-193, 619`: "no `q_*O_D`-as-locally-free-object … once the B3 engine lands, `q_*O_D` is locally free of rank …"). Your rank-0 flat-fp-coherent-sheaf ⟹ zero (Nakayama/support) argument is the *second* arrow and is morally right, but it can't start until fibrewise vanishing is in hand, which the `finrank` carrier doesn't deliver.

**In-project / mathlib lemmas:**
- Would-close-it-*if*-you-had-finite-dim: `Module.finrank_zero_iff` (needs `[FiniteDimensional]`), then a coherent-support/Nakayama step (project has `IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace` and `Module.FinitePresentation.exists_matrixPresentation_of_isLocalizedModule` in `EntryIdeal.lean`/`FiberRankSemicontinuity.lean`).
- The finite-dimensionality itself: **no in-project producer** (B3 unbuilt) and **no mathlib lemma at this pin** — proper-fibre coherent H⁰ finiteness is not available.
- The sibling AJCR *does* have the analogue (`instSubsingletonDivFamZarZeroGeneral`, full `RepresentableBy` in `DivisorFamilyDegreeZeroRep.lean`), but it is **provably non-portable**: it runs on `IsCertified` + `rankAtStalk_eq_zero_iff_subsingleton` over `Away` localisations, *never through a finrank*, on a different carrier (`DivFamZar`). AJC's `fiberDeg` is a `Module.finrank`, so that route cannot transport (`DivFamilyZero.lean:96-105`).

**Bottom line for Q4:** the terminal-representability *bridge* is now landed (I-1690, this lane), so the divisor-side producer is genuinely **one `Subsingleton` short** — but that `Subsingleton` is **not one-session, no-new-hypotheses work**: it requires finite-dimensionality of proper-fibre sections (B3 engine), a real math gap, not just Nakayama plumbing. Every other genuine `rep` producer (concrete-curve picEt) is further blocked (no `Pic(ℙ¹)=ℤ` in AJC or mathlib). Full sections 1-4 written up and ready.

I'll now finalize the full report.

The investigation is complete. Summary of what I delivered to the coordinator, with the key correction that the state moved mid-investigation:

**Section 1 (Div⁰ route):** `DivFamily.zero` (`DivFamilyZero.lean:397`) produces the empty divisor for arbitrary `π, T`, giving `Nonempty ((DivFunctorDeg π 0).obj (op T))`. The OPEN goal is `Subsingleton ((DivFunctorDeg π 0).obj (op T))` (`:82-83`); with it, terminal-representability follows. The bridge `representableByTerminal` just landed (I-1690). Obstruction: `fiberDeg` is a `Module.finrank` with junk value 0, so `HasFiberDeg 0` doesn't imply fibrewise vanishing without finite-dimensionality of fibre sections — the unbuilt B3 engine.

**Section 2:** No concrete-curve picEt producer exists or is started; no `Pic(ℙ¹)=ℤ`, no roadmap row, no lane owns one.

**Section 3:** §7 has `finiteInAffine_sigma` (`:721`) and `finiteInAffine_coprod` (`:757`) but **no** packaged `finiteInAffine_of_iso_sigma`/`_of_sigmaDecomposition` composite — a genuine 2-line gap, though its consumer input (`PicSchemeEt ≅ ∐_d Pic^d`) is the real unbuilt object (absent per `AmbientPicNotProper.lean:120-123`).

**Section 4:** All genuine `rep` producers are blocked on real math (B3 finiteness for Div⁰; `Pic(ℙ¹)=ℤ` for concrete curves). The one session-sized item (`finiteInAffine_of_iso_sigma`) produces `FiniteInAffine`, not `rep`. Nearest miss is Div⁰-by-terminal, one non-portable `Subsingleton` short.
