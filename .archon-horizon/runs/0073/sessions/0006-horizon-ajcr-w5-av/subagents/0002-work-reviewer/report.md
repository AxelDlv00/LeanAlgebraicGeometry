Both items filed (I-0573 issue, I-0574 memory).

# Verdict: CONVERGING, and genuinely so — but the residue statement is overclaimed

This is real progress, not faked. Four commits closed two named clauses with kernel-clean proofs, and the session's own diagnosis of *why* it was cheaper than predicted is correct and reusable. No sorries, no axioms, no placeholders, no helper-churn: every helper in both files is consumed by the theorem below it. The one thing I would not sign is the residue claim — "(iii-c2-aff) alone stands between AJCR and the T5 numeral" — which is not measured and is missing two steps.

## Your three claims, tested

**Claim 1 (iii-c1) — SURVIVES.** `twoChartClassHom_mk_range` (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Tangent/TwoChartNormalize.lean:242`) and `twoChartClass_mk_range` (:257) say what you say they say. Zero diagnostics on the file; axioms `{propext, Classical.choice, Quot.sound}`, no `sorryAx`.

**Claim 2 (iii-c2-Zar) — SURVIVES, including check (b).** At `TwoChartRepresentable.lean:301-303` the hypothesis is `(L : X.CechPic) (hL : ∀ s : Bool, Scheme.CechPic.map (V s).ι L = 1)` — on `L` itself, quantified before any representative is chosen; the `CechPic.ind`/`Quot.ind` pair at :304-307 destructs *after* `hL` is in scope, so no representative was smuggled into the hypothesis. The conclusion is `twoChartClassHom V sel hmem u = L`, an equality in `X.CechPic` — not cohomologousness on a refinement. The refinement `𝒩 ⊓ twoChartCover` appears only *inside* the proof (:314-315), discharged through `CechPic.mk_eq_mk_iff`, which is `Quotient.eq` for the setoid at `Picard/Pic.lean:44` — so it is exactly the equality relation of the quotient, not a weaker one. Axioms clean.

**Claim 3 (no `IsAffine`, no dual numbers, not even `Surjective sel`) — SURVIVES.** `EffectivityTrivialization.lean` has exactly three `variable` lines: `{Z : Scheme}` (:43), `(𝒩 γ D)` (:57), and the `k`-algebra/field block at :242-245 which is *below* the lemma at :75. `grep IsAffine` on the whole file returns nothing. And `lean_minimal_hypotheses` on `twoChartClassHom_surjOn_of_chartTrivial` reports all four explicit binders load-bearing — with `sel`/`hmem` used only to name the target cover, never to select a chart, which is why surjectivity of `sel` is genuinely not needed here (it *is* needed for `twoChartClass_injective`, and `twoChartClass_mk_range` correctly still takes it).

## Your specific checks

**(a) Vacuity — clean.** `IsTrimmedTrivializing` is not degenerate. I probed the worst case (`W = ⊤`, `t = 1`) in a scratch file: the predicate then reduces exactly to "every pair value of `γ` restricts to `1`", i.e. it constrains `γ` and is not satisfied by a canonical witness. `exists_isTrimmedTrivializing` (:74-77) is a faithful re-export — same binders, `h` is the same `CechPic.map W.ι (mk 𝒩 γ.class) = 1`, body is the landed lemma applied directly with nothing weakened.

**(c) Hypothesis usage — clean.** All of `γ`, `ht`, `hu`, `s r`, `b b'`, `hO`, `hs` on `pairCochain_conj` are load-bearing. Note `hu` and `hO`/`hs` fail in the informative way (unsolved goals, not just unbound identifiers), which is the strong form of load-bearing.

**(d) Bijectivity — justified, with one caveat that is not the failure mode you feared.** `twoChartClass_injective` exists at `TwoChartCechPic.lean:449` with binders `(V) (sel) (hmem) (hsel)` matching what `twoChartClass_mk_range` passes. Injectivity plus surjectivity-onto-`range (CechPic.mk (twoChartCover …))` is a bijection onto that subgroup — no compatibility square is needed for *this* claim, because both statements are about the same map `twoChartClass`, not about two maps that must agree. The 381a8050a failure mode does not recur here. It recurs one level up: see below.

**(e) Axioms — clean.** Both theorems: `{propext, Classical.choice, Quot.sound}`. No `sorryAx`. `scan_source` reports no warnings.

**(f) The §6.9 retraction is CORRECT.** `EffectivityMoving.lean` is one-directional as stated. Its three relevant lemmas — `cechPicMap_ι_eq_one_of_le` (:70), `Opens.cechPicMap_ι_eq_one_of_cechPicClass_eq_one` (:101), `Opens.cechPicClass_of_le` (:121) — all go *from* affine-class triviality or a larger open *to* `CechPic.map O.ι L = 1`. There is no converse and no `↔` in the file. The retraction understates nothing and overstates nothing.

## The one finding that matters

**The residue is not (iii-c2-aff) alone.** Two statements between the landed work and the T5 numeral are absent from the tree, and neither is (iii-c2-aff):

1. **Carrier translation at `C_ε`.** The T2 engine computes `Ȟ¹ˣ` of `Γ(X, U₀ ⊓ U₁)[ε]` — dual numbers of the sections of the *original* scheme (`Tangent/TruncExpCechH1.lean:134`). `twoChartClassHom` consumes `Γ(X_ε, V₀ ⊓ V₁)ˣ` — sections of the *thickened* scheme. Nothing identifies them. The bridge would be `Over.sectionsBaseChange` (`Cohomology/SectionsBaseChange.lean:287`) composed with `DualNumber.baseChangeAlgEquiv` (`Tangent/DualNumberBaseChange.lean:119`), plus `sectionsBaseChange_naturality` (:337) for compatibility with the two restrictions. No declaration composes them — the only place both names appear together is a docstring at `DualNumberBaseChange.lean:116`.

2. **The reduction square.** `grep twoChart` intersected with `{CechPic.map, unitsReduction, mapRingHom, unitsFst, truncExp}` returns empty. So even with (iii-c2-aff) discharged, "the ε-kernel is the image of `twoChartClass`" is not derivable. This is the *third* appearance in this lane of the shape the lane itself corrected in `381a8050a` — an iso between the objects at the two ends of a map, with the map-level square missing.

Neither is an error in the landed lemmas; both are missing statements. But worksheet §6.10 and the `AJCR.w5-av.t4` roadmap summary both now assert "residue: (iii-c2-aff) alone", and the next session will budget from that.

**Smaller, docstring-only** (the `I-0349` class): `TwoChartNormalize.lean:19-21` advertises `twoChartClassHom_surjective_of_mk` and `twoChartClass_surjective_of_mk` — neither exists; the actual names are `_mk_range` at :242 and :257. `TwoChartRepresentable.lean:15` advertises `twoChartClass_surjOn_of_chartTrivial`, but the theorem at :301 is `twoChartClassHom_surjOn_of_chartTrivial` and no descended `twoChartClass` version exists.

## Inbox

- **I-0573** (issue) — the two absent steps, with the grep evidence and the request to restate the residue; plus the docstring name mismatches.
- **I-0574** (memory) — "restrict along a `≤`, do not rewrite the type", with the corroborating index-side form and the two tactic facts (`group` ignores commutativity; `rw` under an elided restriction proof).
