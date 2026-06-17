# Strategy Critic Report

## Slug
iter035

## Iteration
035

## Routes audited

### Route: FBC (FBC-A conjugate re-encoding + FBC-B globalization)

- **Goal-alignment**: PASS — closes `affineBaseChange_pushforward_iso` / `flatBaseChange_pushforward_isIso` (the parent's `IsIso pushforwardBaseChangeMap`). Confirmed those are the parent's intended frozen names (`archon-protected.yaml` comment header), so the canonical map's definition is fixed by merge-back and the coherence is genuinely owed — it is **not** a self-imposed obligation that could be dissolved by redefining the map.
- **Mathematical soundness**: PASS — iso-ness is free as `conjugateIsoEquiv adjL adjR` of `gammaPushforwardNatIso`; the module-level content is `regroupEquiv` (done). The remaining work is purely the coherence identifying the abstract conjugate with the concrete canonical map.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags. The route has been re-encoded at least three times (direct-on-sections → term-mode → conjugate-side, with a residual "re-cut codomain read"), each named *inside* STRATEGY.md.
- **Infrastructure-deferral detected**: yes (pivot-avoidance variant) — the hardest prerequisite, the **cross-layer mate coherence** (`base_change_mate_fstar_reindex` / `gstar_transpose`), is the *same* obligation before and after the conjugate pivot; the pivot changes where the coherence is *expressed* (functor layer, conjugate calculus) but not what must be proved. This passes the "pivot moves the same hard problem one layer over" test in my instructions. Mitigant: the conjugate-side expression is discharge-able by *proven Mathlib mate lemmas* (all verified to exist — see Prerequisite verification), which the section-side expression allegedly is not. So it is a defensible re-expression, not pure avoidance — but the burden is on the planner to show the conjugate `_legs` discharge actually *closes*, not merely relocates.
- **Phantom prerequisites**: none — every cited name verified (`leftAdjointCompIso`, `conjugateEquiv_leftAdjointCompIso_inv`, `leftAdjointCompNatTrans`, `unit_conjugateEquiv_symm`, `conjugateIsoEquiv`, `conjugateEquiv_counit_symm`, `tensorEqLocusEquiv`). The conj-0 foundation (`pullbackComp_eq_leftAdjointCompIso`) compiles sorry-free in-file.
- **Effort honesty**: under-counted — "2–4 iters" for what the directive itself calls "the central, long-running blocker" is optimistic given the route has already cycled through multiple encodings. No trip-wire is stated.
- **Parallelism under-exploited**: no — FBC-B build-ahead sub-lane is correctly run in parallel and gated downstream.
- **Verdict**: CHALLENGE — math and infra are sound; the challenge is the re-encoding treadmill + missing trip-wire + optimistic estimate. The planner must (a) state a concrete fallback trigger ("if the conjugate-side `_legs` discharge has not closed by iter N, switch to <fallback>") and (b) re-estimate honestly, OR record an explicit rebuttal in plan.md.

### Route: GF (generic flatness, geometric wrapper)

- **Verdict**: SOUND — algebraic core done; geometric wrapper is a standard affine-cover-of-the-fibre argument; `Module.flat_of_isLocalized_maximal` and `IsLocalization.flat` verified. G1 gated on gap1 is honestly disclosed (see concentration-risk note in Overall verdict).

### Route: QUOT (gap1 descent + Hilbert polynomial + SNAP + repr)

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS — the gap1 decomposition **(C) `overRestrictIso` → (P1) per-affine local-tilde via `Presentation.map` + `isIso_fromTildeΓ_of_presentation` → (D) section-localization descent → assembly via the in-file `..._iff_isLocalizedModule_restrict`** is faithful to the standard proof (Hartshorne II.5.3 / a quasi-coherent sheaf is locally a tilde; finite affine cover + flat localization glues). (D) is correctly identified as the genuine keystone: it supplies the `IsLocalizedModule` hypothesis that P1/assembly consume. All decls (`overRestrictIso`, `qcoh_affine_section_localization`, `isIso_fromTildeΓ_iff`) verified present.
- **Phantom prerequisites**: none — `existsUnique_hilbertPoly` (CharZero), `isIso_fromTildeΓ_iff`, `restrictFunctor` all verified.
- **Effort honesty**: reasonable — QUOT-repr `~400–1000+` LOC / 6–12 iters is honest for representability scope; SNAP/repr correctly BLOCKED.
- **Verdict**: SOUND — with one minor flag: the (D) keystone's exact Stacks tag is not pinned in `references/summary.md` (strategy cites "Stacks 01HA"; the directive cites `lemma-invert-f-sections`; the reference index only carries 01I9 = `widetilde-pullback`, which is the *pullback* formula, not the sections-localization). The strategy already applies "verify before committing prover budget" scepticism to the II.5.17 attribution (Q1); apply the same to the (D) tag.

### Route: GR (Grassmannian scheme → separated → proper)

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS — valuative criterion of properness is the right route. `IsProper`, `UniversallyClosed.of_valuativeCriterion`, `IsSeparated.valuativeCriterion` all verified. The projective/Plücker-embedding alternative would require far more infrastructure (Plücker coordinates, embedding into ℙ^N, `Proj` properness transfer); valuative criterion is correctly the cheaper route for a glued scheme. Real work: the `QuasiCompact`/qcqs side conditions (finite chart cover gives quasi-compactness — fine) and the *existence* part (selecting the chart the valuation's closed point lands in via the matrix-minor structure).
- **Verdict**: CHALLENGE — **not the math, the bookkeeping**: GR-glue and separatedness are DONE in-file (`theGlueData`, `scheme`, `toSpecZ`, `isSeparatedToSpecZ`, `isSeparated`; `GrassmannianCells.lean` has 0 sorry) yet the phase table still marks **GR-glue ACTIVE / 1–2 iters** and Routes still lists "GR-glue (cocycle gluing + diagonal separatedness)" as pending. The live target — properness via the valuative criterion (`gr_proper`) — is not surfaced as its own phase row. Move glue+separated to `## Completed`; add a `GR-proper` row.

## Format compliance

- **Size**: 143 lines / 14385 bytes — line count within budget, **bytes over budget** (~14.0 KB vs ~12 KB). Driver: dense multi-clause `Routes` / `Open strategic questions` prose and long `Risks` cells.
- **Headings**: PASS — exactly `Goal`, `Phases & estimations`, `Completed`, `Routes`, `Open strategic questions`, `Mathlib gaps & new material`, in canonical order.
- **Per-iter narrative detected**: no.
- **Accumulation detected**: yes — (1) GR-glue + separated completed-in-file but still in the active `## Phases & estimations` table (must move to `## Completed`); (2) `## Routes` and `## Open strategic questions` carry *superseded-route narrative inline* ("Direct-on-sections is excluded …", "the term-mode route bottoms out …") — rejected-alternative prose belongs in iter sidecars, not STRATEGY.md.
- **Table discipline**: PASS (columns correct) — but `Risks` cells run to several clauses, contributing to the byte overage.
- **Format verdict**: DRIFTED

## Sunk-cost flags

- `Direct-on-sections (explicit factor telescoping inside the locked goal) is excluded: every keyed rw/simp is dead under the X.Modules diamond and the term-mode route bottoms out at a cross-layer mate coherence with no term-mode form.` — Why this is sunk-cost: it justifies the current encoding by enumerating *prior* failed encodings rather than by showing the new one closes; the inline ledger of dead routes is the treadmill made visible. Recommendation: move the excluded-route reasoning to an iter sidecar; in STRATEGY.md keep only the *positive* claim (which proven Mathlib lemma discharges the conjugate-side `_legs`) plus a trip-wire.

## Prerequisite verification

- `CategoryTheory.Adjunction.leftAdjointCompIso` / `…CompositionIso`: VERIFIED
- `CategoryTheory.Adjunction.conjugateEquiv_leftAdjointCompIso_inv`: VERIFIED
- `CategoryTheory.Adjunction.leftAdjointCompNatTrans`: VERIFIED
- `CategoryTheory.unit_conjugateEquiv_symm`: VERIFIED
- `CategoryTheory.conjugateIsoEquiv`: VERIFIED
- `LinearMap.tensorEqLocusEquiv` (`Mathlib.RingTheory.Flat.Equalizer`): VERIFIED
- `AlgebraicGeometry.Scheme.restrictFunctor` (+ pullback infra, `Modules/Sheaf.lean`): VERIFIED
- `AlgebraicGeometry.isIso_fromTildeΓ_iff` (`Modules/Tilde.lean`): VERIFIED
- `Polynomial.existsUnique_hilbertPoly` (CharZero): VERIFIED
- `Module.flat_of_isLocalized_maximal`, `IsLocalization.flat`: VERIFIED
- `AlgebraicGeometry.IsProper`, `UniversallyClosed.of_valuativeCriterion`, `IsSeparated.valuativeCriterion`: VERIFIED

## Alternative routes (suggested)

### Alternative: FBC-A — affine-local `IsIso` by explicit inverse + element-`ext`, bypassing the mate normal form

- **What it looks like**: In the affine lemma every morphism is between Specs, so `Γ` on `Spec R`-modules is conservative (the tilde/Γ equivalence). Rather than normalizing `pushforwardBaseChangeMap` to its mate composite, *exhibit a two-sided inverse* built from `regroupEquiv` and prove the two round-trips `θ ≫ inv = 𝟙`, `inv ≫ θ = 𝟙` by `ModuleCat`-extensionality (`ext` + element chase). `IsIso` then follows from `isIso_of_..._inv`. Element-`ext` reasons about images of elements, not equalities of locked morphism-composites, so the `X.Modules` transparent-instance diamond that kills keyed `rw`/`simp` never has to be normalized.
- **Why it might be cheaper or sounder**: it discharges a *different* obligation (per-element bijectivity, which the project already has as `regroupEquiv` data) instead of the cross-layer categorical coherence that has resisted multiple encodings. It does not depend on the conjugate calculus closing.
- **What the current strategy may have rejected**: the strategy excludes "direct-on-sections" because "every keyed rw/simp is dead under the diamond" — but that argument is about *rewriting the map to a normal form*, which the explicit-inverse + element-`ext` approach never does. The exclusion may be over-broad.
- **Severity of the omission**: major

## Must-fix-this-iter

- Route FBC: CHALLENGE — state a concrete fallback trigger for the conjugate-side `_legs` discharge (e.g. the affine-local explicit-inverse alternative above) and an honest re-estimate, OR record an explicit rebuttal in plan.md showing the coherence genuinely closes (not relocates) under the verified conjugate lemmas.
- Route GR: CHALLENGE — move GR-glue + separatedness (done, 0 sorry in `GrassmannianCells.lean`) to `## Completed`; add a live `GR-proper` (valuative-criterion) row with the qcqs side conditions and the existence-part chart-selection as the real work.
- Route QUOT: minor — pin the (D) section-localization-descent Stacks tag in `references/summary.md` before spending S1/gap1 prover budget (current 01HA vs `lemma-invert-f-sections` vs indexed-01I9 ambiguity).
- Format: DRIFTED — trim to ≤12 KB by (1) moving GR completed rows out of the active table and (2) relocating the inline excluded-route narrative ("Direct-on-sections is excluded…", "term-mode route bottoms out…") to an iter sidecar.

## Overall verdict

The strategy is mathematically sound and rests on **zero phantom prerequisites** — every Mathlib name across FBC, GF, QUOT, and GR was verified in the pinned tree. Two routes warrant a CHALLENGE. FBC-A is a re-encoding treadmill: the cross-layer mate coherence is the same hardest prerequisite before and after the conjugate pivot, the route has been re-expressed at least three times with the dead encodings recorded inline, and the "2–4 iters" estimate for "the central, long-running blocker" lacks a trip-wire — the planner must either commit to a concrete fallback (the affine-local explicit-inverse + element-`ext` route, which discharges per-element bijectivity instead of the categorical coherence) or rebut why the conjugate-side discharge closes rather than relocates. GR is a bookkeeping CHALLENGE only: gluing and separatedness are done in-file but still occupy an ACTIVE phase row, and the genuinely-live properness target (valuative criterion — the correct, cheaper route over a Plücker embedding) is not surfaced. QUOT's gap1 decomposition (C→P1→D→assembly) is sound and faithful to Hartshorne II.5.3, with only a Stacks-tag-pinning hygiene flag on the (D) keystone. There is a real **keystone-concentration risk** the planner should weigh: gap1 gates GF-G1, the QUOT annihilator, AND the SNAP-S1 route decision, while FBC-A gates the entire FBC merge-back — two hard keystones carry a large fraction of remaining work; the parallel build-ahead lanes (FBC-B, QUOT-defs P2, GR-proper) are the correct hedge and should be kept hot. No infrastructure-deferral that makes the goal unprovable was found — the FBC pivot-avoidance pattern is the one borderline case, mitigated by the verified conjugate API, hence CHALLENGE not REJECT. Format is DRIFTED (over byte budget + accumulation), fixable in-place this iter.
