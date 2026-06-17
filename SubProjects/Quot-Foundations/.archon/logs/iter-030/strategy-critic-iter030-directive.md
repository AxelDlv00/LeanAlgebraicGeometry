# Strategy-critic directive — iter030

Render SOUND / CHALLENGE / REJECT on the strategy below. Fresh-eyes review only — you have no
iter history. Focus on whether the route decomposition is sound and matches the canonical
skeleton of the mathematics (Kleiman FGA / Nitsure / Stacks).

## Project goal (one paragraph)

Formalize the Čech-independent leg of FGA Picard-scheme representability: flat base change of
the i=0 pushforward (FBC), generic flatness (GF), and Quot/Grassmannian foundations (QUOT) —
zero project sorry in the cone, zero project axioms. Names match the parent cone for merge-back.

## Current STRATEGY.md (verbatim)

```markdown
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
| FBC-A — affine lemma, direct-on-sections | ACTIVE | 2–3 | ~60–150 | tilde dictionaries; `conjugateEquiv_counit_symm`, `Adjunction.comp_counit_app` | keyed-rewriting (rw/simp/erw/conv/set/dsimp) CONCLUSIVELY DEAD vs `X.Modules` diamond (iter-029). Residual = ONE hand-built `exact` term, now DECOMPOSED (effort-breaker) into per-`.trans`-link clean-term sub-lemmas (single instance ⇒ no diamond, ≤30 LOC each) + fine-grained assembly. OVER_BUDGET (entered iter-018); escalate to user if not closed by iter-032 |
| FBC-B — globalization, H⁰-equalizer | NEXT | 2–5 | ~120–300 | `Mathlib.RingTheory.Flat.Equalizer`; finite affine cover + sheaf condition for `SheafOfModules` | flat-equalizer half Mathlib-backed; residual = H⁰-as-equalizer packaging. Sequenced after gstar |
| GF-geo — `genericFlatness` | ACTIVE | 2–4 | ~120–300 | algebraic core (done); `Module.flat_of_isLocalized_maximal`; `HasRingHomProperty.appLE` | base `[IsIntegral S]`+`[QuasiCompact p]` required (else false). G1/G3 Mathlib-absent, project-built; G1 bottoms at gap1 (QUOT-side) — GF dispatch deferred until gap1 lands |
| GR-glue — `Grassmannian.scheme` by gluing charts | ACTIVE | 1–3 | ~120–320 | `Scheme.GlueData`/`Multicoequalizer`; charts+transitions+cocycle (DONE) | self-contained, NO keystone dep; the one fully-unblocked lane. cocycle ring identity + glued scheme → separated → proper |
| QUOT-defs — Quot/Grassmannian defs + predicates | ACTIVE (infra-gated) | 4–8 | ~220–560 | `Scheme.Modules.restrictFunctor`/`pullback` (EXIST); `Presentation.map`; `QuasicoherentData.bind` template | gap1 decomposed (analogist iter-030) into 4 steps: (C) `overRestrictIso` bridge, (P1) per-affine local-tilde, (D) section-localization descent [keystone, Stacks 01HA], (4) assembly via the in-file iff. (C)/(D) are the two new lemmas; rest is Mathlib glue. annihilator/SNAP gated; 4 stubs protected |
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

## Routes

Single route per target; the leg is a fan of independent leaves merging back upstream. FBC-A and
GF-geo are the live frontier; QUOT is authorable in parallel (all four files import only Mathlib).
FBC-B follows FBC-A; QUOT-repr follows QUOT-defs, SNAP, and the RelativeSpec strengthening.

**FBC route.** Prove the affine lemma **directly on global sections** (Stacks 02KH part 2), rewriting
both sides through the proved tilde dictionaries (`pullback_spec_tilde_iso`, `pushforward_spec_tilde_iso`)
and the regroup iso `regroupEquiv` (DONE). The section identity is a **domain read + codomain read +
g^*-transpose** triangle; `domain_read`/`codomain_read` are axiom-clean. The crux is **Seam 3
gstar_transpose**, a 5-lemma chain: Seam A inner value `Γ_R(θ_in)=ρ`, Seam B generator close, Seam C
counit transport (proven `conjugateEquiv_counit_symm`). Seam A routes THROUGH the leg-parametrised
`fstar_reindex`/`fstar_reindex_legs` (post-subst, leg `= e ≫ Spec ιA` definitionally) — NOT inline at
the projection legs (WALLED: dependent-motive obstruction). The `_legs` step-(iii) eCancel assembly and
`gstar_transpose` both close by the **term-mode mechanism**: splice the SHIPPED eCancel atoms via
`congrArg`/`Functor.congr_map`/`.trans`/`exact`, NOT keyed `rw`/`simp`/`erw` (defeated by the `X.Modules`
instance diamond). Globalize **Čech-cohomology-free**: `H⁰(X,F)` is the equalizer `∏Γ(Uᵢ,F) ⇉ ∏Γ(Uᵢⱼ,F)`
(sheaf condition, degree 0/1), and a flat `−⊗B` preserves that finite equalizer.

**GF route.** Algebraic core `genericFlatnessAlgebraic` DONE (Nitsure §4 induction, base-domain
generalization). Geometric `genericFlatness` (`[IsQuasicoherent]`+`[IsFiniteType]`) wraps it: pass to a
non-empty affine open `Spec A ⊆ S` (A noetherian domain), cover `p⁻¹(Spec A)` by finitely many affine
`W_j = Spec B_j` (finite-type over A), read `M_j = Γ(F,W_j)` finite over `B_j`, apply the algebraic form
per patch for `f_j ≠ 0`, take `V = D(∏ f_j)`, conclude flatness from freeness over the localisation. G1
(finite-section module on affine) bottoms at gap1.

**QUOT route.** Foundational decisions:
- *Hilbert-polynomial encoding = graded Hilbert function.* `def:hilbert_polynomial` = the polynomial
  `Φ_s` agreeing for `m≫0` with `m ↦ dim_{κ(s)} Γ(X_s, F_s ⊗ L_s^m)` of a f.g. graded module
  (Hartshorne I.7.5; Nitsure §1). Routes through `Polynomial.existsUnique_hilbertPoly` (`[CharZero]`) +
  the graded Hilbert–Serre rationality `lem:gradedHilbertSerre_rational` (DONE, axiom-clean). Same
  polynomial as the cohomological χ without higher cohomology.
- *Rationality engine = Route 2* (Stacks 00K1 over pairs `N'≤N` of submodules of a FIXED ambient graded
  κ-module — avoids the quotient-carrier `isDefEq` pathology). DONE.
- *SNAP-S1 input* (GATED — Open Q1). Primary route: chosen f.g. presentation — every coherent `F` on
  `Proj S` is `M̃` for a f.g. graded `M` (f.g. by construction), sidestepping the doubtful "Γ_*(F) f.g."
  lemma. Canonicity of `Φ_s` may need a Serre `m≫0` agreement; resolve route before any S1 prover.
- *QUOT-defs predicate sub-builds*: P1 schematic-support + `IsProper` DONE; P2 rank-`r` local-freeness
  for `SheafOfModules` NEXT. `Grassmannian := QuotFunctor (𝟙 S) V Φ_d`. Forward annihilator char. is
  bridge-gated on `lem:qcoh_section_localization_basicOpen` ≡ gap1 (source-grep verified; local/stalk
  shortcuts do NOT avoid it). gap1 route (analogist iter-030): (C) `overRestrictIso` →
  (P1) per-affine local-tilde via `Presentation.map`+`isIso_fromTildeΓ_of_presentation` →
  (D) section-localization descent → (4) assembly via the in-file `..._iff_isLocalizedModule_restrict`.
- *QUOT-repr decomposed*: GR-cells (DONE); GR-glue (cocycle gluing + diagonal separatedness); GR-quot
  (tautological rank-`d` quotient + universal property); GR-repr (functor-of-points ⟹ `RepresentableBy`,
  needs `thm:relative_spec_univ` strengthened via `representableByEquiv`).

## Open strategic questions

- **Q1 — SNAP route DECISION (blocks S1; pick one, then sub-build).** Canonicity of `Φ_s` across graded
  presentations needs either (a) chosen-presentation `Φ_s` + a cited Serre `m≫0` agreement, or (b) an
  H¹-free finiteness with an exact reference. Decision: defer the pick until gap1 lands (gap1 unblocks
  GF-G1 + the annihilator, higher leverage); trigger = once gap1 closes, dispatch a reference-retriever
  for the Serre `m≫0` agreement (the "Hartshorne II.5.17" attribution is unverified/likely wrong — read
  before committing), and decide (a) vs (b). The `def:sectionGradedRing` tensor-powers sub-build is a
  separate Mathlib-gradient prerequisite owed regardless.
- **Merge-back signature check.** Confirm the re-signed `genericFlatness`/QUOT decls
  (`[IsQuasicoherent]`+`[IsFiniteType]`) match the parent cone's expected signatures.
- **Shared qcoh-affine-local infra (GF-G1 ∩ QUOT).** Both bottom at the same `isLocalizedModule_basicOpen`
  ≡ gap1 node, now decomposed into (C) `overRestrictIso` + (D) section-localization descent (the latter is
  the shared reusable keystone). Decision (iter-024): build it ONCE QUOT-side (its `Scheme.Modules.*`
  namespace + blueprint home + a live consumer), NOT a copy in FlatteningStratification. Once gap1 lands,
  a mathlib-analogist API-alignment pass gates shared-extraction vs adding the import.

## Mathlib gaps & new material

Gaps to fill (detail in Routes):
- FBC-A: section-level inner value chain + counit-transport coherence (term-mode mechanism, no new lemma).
- FBC-B: H⁰-as-equalizer / finite-affine-cover sheaf-condition packaging for `SheafOfModules`.
- GF-geo: **G1** (qcoh+finite-type ⟹ `Γ(F,W)` finite on affine `W`, via gap1) and **G3** (flat-locality
  assembly: per-patch freeness on a finite cover ⟹ flatness over `Γ(S,U)`).
- **gap1 — QCoh≃Mod affine descent (keystone bottom):** `IsQuasicoherent M → IsIso M.fromTildeΓ` on
  `Spec R`. Mathlib has `isIso_fromTildeΓ_iff` + the global-`Presentation` case only. The in-file iff
  engine + finite-cover front DONE. Two genuinely-missing lemmas remain (analogist iter-030,
  `analogies/quot-gap1-transport.md`): **(C) `overRestrictIso`** — the `M.over U ↔ M.restrict U.ι /
  Spec R_r` bridge (the ONE lemma touching the slice site; `backward.isDefEq.respectTransparency false`
  tames the synthInstance timeout); **(D) section-localization descent** (Stacks 01HA / Hartshorne
  II.5.3) — the real keystone (sheaf equalizer + `IsLocalization.flat` over the finite cover). NOTE:
  obstacle "no restriction functor" was FALSE — `Scheme.Modules.restrictFunctor`/`pullback` exist.
- **SheafOfModules tensor powers (blocks `def:sectionGradedRing` ⟹ SNAP):** `L_s^{⊗m}` + lax-monoidal `Γ`
  absent; Mathlib-gradient sub-build owed before SNAP.
- QUOT predicates: rank-`r` local-freeness for `SheafOfModules`. QUOT-repr: Grassmannian-of-quotients as
  a scheme (Nitsure §1/§5 big-cell patching).

New project material:
- `genericFlatnessAlgebraic` (done), re-signed `genericFlatness` (+`IsQuasicoherent`+`IsFiniteType`).
- Coherence encoding = `[IsQuasicoherent]` + `[IsFiniteType]` over the locally noetherian base.
- QUOT defs with tightened signatures; `Grassmannian` via `QuotFunctor`; representability as `IsRepresentable`.
```

## References index (references/summary.md)

```markdown
# References

<!-- archon:references-summary -->

| File | Description |
| ---- | ----------- |
| [`nitsure-hilbert-quot.md`](./nitsure-hilbert-quot.md) → `nitsure-hilbert-quot.pdf` / `-src/*.tex` | Nitsure, "Construction of Hilbert and Quot Schemes" (FGA Explained / arXiv:math/0504590). **The primary source for this subproject.** §1 Hilbert polynomial (Snapper), §2 the Quot functor, **§4 "Lemma on Generic Flatness"** (full induction proof, src L1711–1772 — backs `thm:generic_flatness_algebraic`), §5 Grassmannian + Quot construction (backs `def:grassmannian_scheme` / `thm:grassmannian_representable`). |
| [`stacks-coherent.md`](./stacks-coherent.md) → `stacks-coherent.tex` | Stacks ch.30 "Cohomology of Schemes" — tag **02KH** (flat base change of `R^i f_*`; part (2) `H^0`-with-base-change). Backs `thm:flat_base_change_pushforward` / `lem:affine_base_change_pushforward` in `Cohomology_FlatBaseChange.tex`. |
| [`stacks-schemes.md`](./stacks-schemes.md) → `stacks-schemes.tex` | Stacks ch. "Schemes" (tag 020J) — **tag 01I9** = `lemma-widetilde-pullback` (§7 "Quasi-coherent sheaves on affines", line 1242): `ψ* M̃ = (S⊗_R M)~` and `ψ_* Ñ = (N_R)~` for affine `ψ: Spec(S)→Spec(R)`. Direct source for the proved `lem:pullback_spec_tilde_iso` in `Cohomology_FlatBaseChange.tex`. |
| [`stacks-constructions.md`](./stacks-constructions.md) → `stacks-constructions.tex` | Stacks ch.27 "Constructions of Schemes" — tags **01LL**/**01LO**/**01LQ**/**01LR**/**01LS** (relative-spectrum chapter: situation, glueing, functor `F`, base change). **Caveat**: 01LL is a SECTION label, 01LO is the transitivity (NOT affine-case) lemma, 01LR is the eqn defining `F`. Adjacent tags **01LM**, **01LP**, **01LT** (the affine base case) are the likely real quote targets — see pointer file caveats. Backs `Picard_RelativeSpec.tex`. |
| [`hartshorne-algebraic-geometry.md`](./hartshorne-algebraic-geometry.md) → `hartshorne-algebraic-geometry.pdf` | Hartshorne, "Algebraic Geometry" (GTM 52, 1977). Background companion for the Quot/Grassmannian chapter (II.§5 quasi-coherent sheaves, II.§7 Grassmannians/projective morphisms, III.§9 flat families & Hilbert polynomials). Offset +17 (body). Scanned image PDF. |
| [`hilbert-serre.md`](./hilbert-serre.md) → `hilbert-serre-algebra.tex` | Stacks Project "Algebra", §"Noetherian graded rings" (tag **00JV**, lines 13778–13986). **Tag 00K1** (`proposition-graded-hilbert-polynomial`, lines 13893–13948) = Hilbert–Serre rationality: n↦[Mₙ]∈K'₀(S₀) is a numerical polynomial when S₊ is generated in degree 1. Inductive proof via SES 0→Mₐ→Mₐ₊₁→M̄ₐ₊₁→0 at lines 13939–13947. Backs `lem:gradedHilbertSerre_rational` in `Picard_QuotScheme.tex`. Use `Read` with `offset: 13778, limit: 210`. |
| [`stacks-properties.md`](./stacks-properties.md) → `stacks-properties.tex` | Stacks ch. "Properties of Schemes" (5424 lines). **Tag 01PB** = `lemma-finite-type-module` (lines 2092–2110, §"Characterizing modules of finite type and finite presentation", tag 01PA at line 2075): `M̃` is finite-type iff `M` is finite `R`-module. Also **tag 01B5** = `modules-definition-finite-type` (in modules.tex, lines 809–817): the base definition of finite-type O_X-module. Backs `lem:gf_qcoh_fintype_finite_sections` in `Picard_FlatteningStratification.tex`. Use `Read offset:2092 limit:19`. |
```

## Blueprint chapters (title + topic)

- Cohomology_FlatBaseChange.tex — Flat base change for pushforward of a QCoh sheaf (i=0); Stacks 02KH.
- Cohomology_RegroupHelper.tex — Regrouping iso for the affine base-change tensor tower (DONE).
- Picard_FlatteningStratification.tex — Flattening stratification / generic flatness (Nitsure §4).
- Picard_GrassmannianCells.tex — The Grassmannian over ℤ: big-cell charts, transitions, cocycle, gluing.
- Picard_QuotScheme.tex — The Quot scheme: Hilbert polynomial, Quot/Grassmannian functors, QCoh≃Mod gap1, predicates.
- Picard_RelativeSpec.tex — Relative Spec.
