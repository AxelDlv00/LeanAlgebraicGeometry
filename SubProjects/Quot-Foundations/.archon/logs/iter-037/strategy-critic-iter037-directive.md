# Strategy-Critic Directive — iter-037 (Quot-Foundations)

You are the fresh-context strategy critic. Read the strategy below as a fresh mathematician would.
Challenge structural soundness, sunk cost, missing prerequisites, hallucinated routes. You have NO
iter-by-iter history — that is intentional.

## Project goal (one paragraph)

Close the `sorry`-bearing nodes of the **Čech-independent leg** of the parent's
`thm:fga_pic_representability` cone (Kleiman, "The Picard scheme", FGA §4): (FBC) the i=0 flat base
change map `g^* f_* F ⟶ f'_* g'^* F` is an iso (Stacks 02KH); (GF) generic flatness with algebraic core
(Nitsure §4); (QUOT) Hilbert polynomial, Quot functor, Grassmannian scheme + representability (Nitsure
§1/§5). End-state: zero project `sorry` in the cone, kernel-only axioms. Names/labels are the parent's so
the work merges back.

## Blueprint chapters (title + one-line topic)

- Cohomology_FlatBaseChange.tex — flat base change for pushforward of a qcoh sheaf (i=0); the affine
  lemma `IsIso pushforwardBaseChangeMap` and its conjugate-counit coherence.
- Cohomology_RegroupHelper.tex — the regrouping iso `(A⊗_R R')⊗_A M ≅ R'⊗_R M` (DONE).
- Picard_FlatteningStratification.tex — flattening stratification / generic flatness (algebraic core DONE).
- Picard_GrassmannianCells.tex — the Grassmannian over ℤ: charts, glue, separated, proper (valuative).
- Picard_QuotScheme.tex — the Quot scheme: Hilbert poly, Quot functor, gap1 QCoh≃Mod affine descent.
- Picard_RelativeSpec.tex — relative Spec.

## References index


## STRATEGY.md (verbatim)

```
# Strategy

## Goal

Close the `sorry`-bearing nodes of the **Čech-independent leg** of the parent's
`thm:fga_pic_representability` cone (Kleiman FGA, "The Picard scheme", §4), then merge back:

- **FBC** — `lem:affine_base_change_pushforward` + `thm:flat_base_change_pushforward`
  (the i=0 base-change map `g^* f_* F ⟶ f'_* g'^* F` is an isomorphism).
- **GF** — `thm:generic_flatness` with algebraic core `thm:generic_flatness_algebraic`.
- **QUOT** — `def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`,
  `thm:grassmannian_representable`.

End-state: zero project `sorry` in the 29-node closure, zero project axioms, kernel-only axioms.
Names/labels are the parent's so finished work merges back into its A.2.c engine.

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| FBC-A — affine lemma, conjugate-counit `huce` endgame | ACTIVE (assembly round) | 1–2 | ~80–150 | `conjugateEquiv_counit_symm` (master `huce`, landed); all sub-ingredients proved | endgame: steps (b)/(c) PROVED, `huce` assembled; remaining is inline step-(a) reindex + dictionary-cancellation glue of proved atoms. Tripwire: if glue fails to close `gstar_transpose` AND no inline step-(a) lemma lands → iter-038 mathlib-analogist on the cancellation |
| FBC-B — globalization, H⁰-equalizer | ACTIVE (parallel lane, split-out file) | 2–4 | ~120–300 | `isSheaf_iff_isSheafEqualizerProducts`, `tensorEqLocusEquiv`; finite affine cover | eqLocus sub-lane DONE; chain assembly gated on FBC-A affine sorry; in `FlatBaseChangeGlobal.lean` |
| GF-geo — `genericFlatness` | BLOCKED (gap1-gated) | 2–4 | ~120–300 | `flat_of_isLocalized_maximal`; `HasRingHomProperty.appLE` | G1 bottoms at gap1; dispatch deferred until gap1 lands |
| GR-proper — `isProper` via valuative criterion | ACTIVE (E3-full) | 1–3 | ~120–280 | `Matrix.det_updateColumn`/cofactor-expansion of a column-substituted identity | separated + E1/E2/E3-ratio-core DONE; E3-full bottoms at the cofactor-entry-as-minor helper (the one flagged matrix gap), then E4/`valuativeExistence` close |
| QUOT-defs — Quot/Grassmannian defs + predicates | ACTIVE (gap1 Hfr ingredients) | 3–6 | ~180–460 | (I) ring-iso-semilinear `IsLocalizedModule` transport; (II) base-change-of-localization `R→R_r` | gap1: C+P1+D(cover)+`gammaPullbackTopIso` DONE; remaining = ingredients (I)/(II) → Hfr → named descent + gap1; 4 stubs protected |
| SNAP-S1/S3 — section-module input + `Φ_s` extraction | BLOCKED | 3–6 | ~150–400 | `SheafOfModules` tensor powers of `L_s`; `existsUnique_hilbertPoly` | GATED on a route decision (Open Q1) + `def:sectionGradedRing` (tensor-powers sub-build) |
| QUOT-repr — `thm:grassmannian_representable` | BLOCKED | 6–12 | ~400–1000+ | Grassmannian-of-quotients as a scheme; RelativeSpec → `RepresentableBy` | deepest target; GR-cells DONE; GR-glue/quot/repr in Routes |

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|---|
| GF-alg — algebraic core | 022 · ~9 | ~900 | FlatteningStratification.lean | `genericFlatnessAlgebraic` axiom-clean (Nitsure §4 dévissage); L4/L5 axiom-clean | `g:=g0·g1` + `IsIntegral.exists_multiple_integral_of_isLocalization`; ring↔module bridge `IsLocalizedModule.iso` + `LinearEquiv.extendScalarsOfIsLocalization`; strong induction generalizing base domain | hand-built `Algebra A Cg` via `letI` is an `isDefEq` dead end (use ambient instances); deep stack needs `maxHeartbeats 1600000` |
| FBC RegroupHelper | 011 · 4 | ~120 | Cohomology_RegroupHelper | `regroupEquiv` `(A⊗_R R')⊗_A M ≅ R'⊗_R M` axiom-clean | `eT` identity-bridge + `TensorProduct.induction_on` to beat transparent-instance diamonds | element `map_smul'` zero-branch needed `erw [TensorProduct.zero_tmul]` |
| GR-cells (charts+cocycle) | 012 · 2 | ~600 | GrassmannianCells.lean | big-cell charts, transition maps, `lem:gr_cocycle` — 28 decls | `IsLocalization.Away.lift` for localized transition maps; prove distributed-matrix forms by `exact` then `rw` | `rw [Matrix.map_mul]` fails on Away-base-changed matrices (hidden `algebraMap` diamond) |
| SNAP-S2 power-series engine | 012 · 1 | ~180 | QuotScheme.lean (`IsRatHilb`) | antidifference + `IsRatHilb.ofDiffEq` (power-series half of Stacks 00K1), 8 decls | telescoping via `invOneSubPow`; `IsRatHilb` predicate isolates series bookkeeping | `PowerSeries.C` ring arg implicit; `open … in` must precede docstring |
| SNAP-S2 graded Hilbert–Serre rationality | 020 · 9 | ~1290 | GradedHilbertSerre.lean | keystone `gradedModule_hilbertSeries_rational` (Stacks 00K1) axiom-clean | Route-2 ambient-subquotient pairs (`Naux⊓ℳn`) sidestep quotient-carrier gradings | bundled `DirectSum.Decomposition`/`IsInternal` over quotient/subtype carrier is a hard `isDefEq` dead end (Route 2 supersedes) |
| QUOT-defs P1 predicates | 011 · 1 | ~90 | QuotScheme.lean | schematic-support, proper-support via `IdealSheafData.ofIdeals`/`.subscheme` | annihilator-ideal-sheaf needs NO QCoh bridge | — |
| GR-glue — glued Grassmannian scheme | 031 · 3 | ~220 | GrassmannianCells.lean | `Grassmannian.scheme`=`theGlueData.glued` axiom-clean; `cocyclePhiId` (Φ=id) via telescoped rotated cocycle | `Scheme.GlueData` `f_mono`/`f_hasPullback` default `infer_instance` works; cocycle telescopes to ONE inverse pair via rotMid+cocycleCondition; matrix engine closes it | `HasPullback` instance diamond needs `maxHeartbeats 1600000`+`erw`; 2-iter no-output was a dispatch-wording bug (0-sorry file needs scaffold keyword) |
| QUOT gap1 bridge C — `overRestrictIso` | 031 · 2 | ~120 | QuotScheme.lean | `overRestrictIso`/`overRestrictPullbackIso` axiom-clean; over-site↔open sheaf equivalence | step-2 ring-sheaf id collapses to `rfl` (`toScheme_presheaf` defeq); `pushforwardPushforwardEquivalence`+`pushforwardComp`/`pushforwardCongr`; `cat_disch` for `Sheaf.Hom` wrappers | `rw [id_comp]`/`rw [← op_comp]` fail syntactic-match on Over/op category — use `erw`+separate `have`+`exact (congrArg map h).trans` |
| GR-sep — separatedness | 034 · 1 | ~150 | GrassmannianCells.lean | `isSeparated`/`isSeparatedToSpecZ` via route (b); `diagonalRingMap_surjective` (surjective restricted diagonal) | `Spec ℤ` genuinely terminal for `Scheme.{0}` collapses glue to `IsTerminal.hom_ext`; faithful `Proj.isSeparated` port; per-patch closed immersion from `diagonalRingMap_surjective` | `convert!`/`pullback.map_fst` don't exist; `Spec.map_comp` rw fails on the Scheme-cat diamond — use `IsTerminal.hom_ext` |

## Routes

Single route per target; the leg is a fan of independent leaves merging back upstream. FBC-A and
GF-geo are the live frontier; QUOT is authorable in parallel (all four files import only Mathlib).
FBC-B follows FBC-A; QUOT-repr follows QUOT-defs, SNAP, and the RelativeSpec strengthening.

**FBC route.** The affine lemma (Stacks 02KH part 2) is `IsIso pushforwardBaseChangeMap`; iso-ness is
free as `conjugateIsoEquiv adjL adjR` of `gammaPushforwardNatIso`, and the module-level content is
`regroupEquiv` (DONE). The remaining work is the coherence identifying that abstract conjugate with the
concrete canonical map: the **domain read + codomain read + g^*-transpose** triangle, whose live residual
is `gstar_transpose`. Because `pushforwardBaseChangeMap` is *defined* as the `(g^*⊣g_*)` transpose, any
section-level evaluation unfolds (`Adjunction.homEquiv_counit`) to this mate form — so the close is on the
**conjugate-counit side**, via the master transport identity `huce` (`conjugateEquiv_counit_symm` of the
comparison, landed and assembled). Its remaining pieces are all PROVED standalone: step (b) generator
close (`gstar_generator_close`) and step (c) `huce` (`gstar_counit_transport`); the only open work is the
**assembly glue** — reproving the inner reindex `Γ_R(θ_in)=ρ` INLINE from the proved `inner_eCancel_*`
atoms (NOT the dead `_legs`/conj-2a cluster, which is off the critical path) plus the dictionary
cancellation against `Θ_src`/`Θ_tgt`. Element-`ext` is rejected (the geometric counit has no element-level
normal form — documented dead end `FlatBaseChange.lean:2097`). Globalize **Čech-cohomology-free**:
`H⁰(X,F)` is the finite equalizer `∏Γ(Uᵢ,F) ⇉ ∏Γ(Uᵢⱼ,F)` and a flat `−⊗B` preserves it — independent of
the affine `gstar_transpose`, run as a parallel lane in `FlatBaseChangeGlobal.lean` (eqLocus sub-lane DONE;
chain assembly gated on the affine sorry).

**GF route.** Algebraic core `genericFlatnessAlgebraic` DONE (Nitsure §4 induction). Geometric
`genericFlatness` (`[IsQuasicoherent]`+`[IsFiniteType]`) wraps it: affine open `Spec A ⊆ S`, finite
affine cover of `p⁻¹(Spec A)`, algebraic form per patch, `V = D(∏ f_j)`, freeness over the localisation.
G1 (finite-section module on affine) bottoms at gap1.

**QUOT route.** Foundational decisions:
- *Hilbert-polynomial encoding = graded Hilbert function.* `def:hilbert_polynomial` = the polynomial `Φ_s`
  agreeing for `m≫0` with `m ↦ dim_{κ(s)} Γ(X_s, F_s ⊗ L_s^m)` (Hartshorne I.7.5; Nitsure §1), via
  `Polynomial.existsUnique_hilbertPoly` (`[CharZero]`) + `lem:gradedHilbertSerre_rational` (DONE).
- *Rationality engine = Route 2* (Stacks 00K1 over pairs `N'≤N` in a FIXED ambient graded κ-module —
  avoids the quotient-carrier `isDefEq` pathology). DONE.
- *SNAP-S1 input* (GATED — Open Q1). Primary route: chosen f.g. presentation — every coherent `F` on
  `Proj S` is `M̃` for a f.g. graded `M` (f.g. by construction), sidestepping the doubtful "Γ_*(F) f.g."
  lemma. Canonicity of `Φ_s` may need a Serre `m≫0` agreement; resolve route before any S1 prover.
- *QUOT-defs predicate sub-builds*: P1 schematic-support + `IsProper` DONE; P2 rank-`r` local-freeness
  for `SheafOfModules` NEXT. `Grassmannian := QuotFunctor (𝟙 S) V Φ_d`. Forward annihilator char. is
  bridge-gated on `lem:qcoh_section_localization_basicOpen` ≡ gap1 (source-grep verified; local/stalk
  shortcuts do NOT avoid it). gap1 route: (C) `overRestrictIso` (DONE) →
  (P1) per-affine local-tilde via `Presentation.map`+`isIso_fromTildeΓ_of_presentation` (DONE) →
  (D) section-localization descent, cover form `_of_cover` (DONE; Stacks `lemma-invert-f-sections` /
  Hartshorne II.5.3) + `gammaPullbackTopIso` section transport (DONE) → remaining: build the two
  Mathlib-absent bridges (I) ring-iso-semilinear `IsLocalizedModule` transport, (II) base-change-of-
  localization `R→R_r`, assemble `Hfr`, instantiate `_of_cover` → (4) assembly via the in-file
  `..._iff_isLocalizedModule_restrict`.
- *QUOT-repr decomposed*: GR-cells + GR-glue + GR-sep (DONE); GR-proper reduced to
  `ValuativeCriterion.Existence (toSpecZ)`, with E1/E2/E3-ratio-core DONE and E3-full the live target;
  GR-quot (tautological rank-`d` quotient + universal property); GR-repr (functor-of-points ⟹
  `RepresentableBy`, needs `thm:relative_spec_univ` strengthened via `representableByEquiv`).

## Open strategic questions

- **Q1 — SNAP route DECISION (blocks S1).** Canonicity of `Φ_s` needs either (a) chosen-presentation `Φ_s`
  + a cited Serre `m≫0` agreement, or (b) an H¹-free finiteness with a reference. Defer the pick until
  gap1 lands (higher leverage); trigger = once gap1 closes, retrieve the Serre `m≫0` agreement (the
  "Hartshorne II.5.17" attribution is unverified — read before committing) and decide. `def:sectionGradedRing`
  tensor-powers sub-build is owed regardless.
- **Q2 — FBC `gstar_transpose` close (RESOLVED to the conjugate-counit `huce` vehicle; assembly only).**
  Both element-`ext` (no element-level normal form for the geometric counit — `FlatBaseChange.lean:2097`)
  and the `_legs`/conj-2a section-composite reframing (5-iter stall) are ABANDONED and off the critical
  path. The live vehicle is the conjugate-counit `huce` calculus applied to `gstar_transpose` directly:
  steps (b)/(c) and `huce` are PROVED/assembled, so the only open obligation is the assembly glue (inline
  step-(a) reindex from proved `inner_eCancel_*` atoms + dictionary cancellation). **Escalation (not a
  route fork):** if the assembly round closes nothing AND no inline step-(a) lemma lands, iter-038 =
  mathlib-analogist consult on the dictionary cancellation — NOT another vehicle pivot, NOT user escalation.
- **Merge-back signature check.** Confirm the re-signed `genericFlatness`/QUOT decls
  (`[IsQuasicoherent]`+`[IsFiniteType]`) match the parent cone's expected signatures.
- **Shared qcoh-affine-local infra (GF-G1 ∩ QUOT).** Both bottom at gap1 = (C) `overRestrictIso` (DONE) +
  (D) descent. Build it ONCE QUOT-side (`Scheme.Modules.*` + a live consumer), NOT a copy in
  FlatteningStratification; once gap1 lands, an API-alignment pass gates shared-extraction vs import.

## Mathlib gaps & new material

Gaps to fill (detail in Routes):
- FBC-A: `gstar_transpose` close — assembly glue of proved atoms on the conjugate-counit `huce` side
  (inline step-(a) reindex + dictionary cancellation; no new Mathlib).
- FBC-B: H⁰-as-equalizer / finite-affine-cover sheaf-condition packaging for `SheafOfModules`.
- GF-geo: **G1** (qcoh+finite-type ⟹ `Γ(F,W)` finite on affine `W`, via gap1) and **G3** (per-patch
  freeness on a finite cover ⟹ flatness over `Γ(S,U)`).
- **gap1 — QCoh≃Mod affine descent (keystone bottom):** `IsQuasicoherent M → IsIso M.fromTildeΓ` on
  `Spec R`. `isIso_fromTildeΓ_iff`/`_of_presentation` PROJECT-side (DONE); (C)+(P1)+(D cover form)+
  `gammaPullbackTopIso` DONE. Remaining: **(I)** ring-iso-semilinear `IsLocalizedModule` transport +
  **(II)** base-change-of-localization `R→R_r` ⟹ `Hfr` ⟹ named descent, then (4) assembly.
- **SheafOfModules tensor powers (blocks `def:sectionGradedRing` ⟹ SNAP):** `L_s^{⊗m}` + lax-monoidal `Γ`
  absent; Mathlib-gradient sub-build owed.
- QUOT predicates: rank-`r` local-freeness for `SheafOfModules`. QUOT-repr: Grassmannian-of-quotients as
  a scheme (Nitsure §1/§5 big-cell patching).

New project material:
- `genericFlatnessAlgebraic` (done), re-signed `genericFlatness` (+`IsQuasicoherent`+`IsFiniteType`).
- Coherence encoding = `[IsQuasicoherent]` + `[IsFiniteType]` over the locally noetherian base.
- QUOT defs with tightened signatures; `Grassmannian` via `QuotFunctor`; representability as `IsRepresentable`.

```

## Focus this iter

STRATEGY.md changed this iter ONLY in the FBC route + Q2 + the FBC/GR/QUOT phase rows: the FBC-A vehicle was re-described from the (abandoned) `_legs`/conjugateEquiv-injective atomization to the conjugate-counit `huce` endgame (steps (b)/(c) PROVED, `huce` assembled; remaining = inline step-(a) reindex from proved `inner_eCancel_*` atoms + dictionary cancellation glue). Confirm: (1) is the FBC close honestly characterized as assembly-of-proved-atoms rather than a fresh route, or is this another re-encoding treadmill? (2) are the GR E3-full (cofactor-expansion matrix gap) and QUOT (I)/(II) ingredient builds correctly scoped and referenced? (3) any missing prerequisite or hallucinated Mathlib anchor.
