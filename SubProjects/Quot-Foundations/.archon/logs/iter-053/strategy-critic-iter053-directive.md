# Strategy-critic — iter-053 fresh strategic audit

Audit STRATEGY.md (verbatim below) against the references + blueprint topic map.
Focus: the GF route was just changed this iter (stalk route confirmed dead → re-spec around
**source-span descent** via Module.flat_of_isLocalized_span + an algebraic brick
gf_flat_localizedModule_sameBase + geometric Γ(F,D(g))≅(M_j)_g descent). Is this sound, or is
there a simpler/correct route? Also re-verify the FBC-A keystone challenge (still live from iter-050)
and Q1 SNAP-canonicity remain addressed.

## Project goal (one paragraph)
Close the sorry-bearing nodes of the Čech-independent leg of the parent's thm:fga_pic_representability
cone (Kleiman FGA 'The Picard scheme' §4): flat base change i=0 (FBC), generic flatness (GF), and the
Quot/Grassmannian foundations (QUOT). End-state: zero project sorry in the 29-node closure, kernel-only axioms.

## STRATEGY.md (verbatim)
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

End-state: zero project `sorry` in the 29-node closure, zero axioms (kernel-only). Names/labels are the
parent's so finished work merges back into its A.2.c engine.

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| FBC-A1 — affine iso (mate `gstar_transpose`) | PARKED | 2–4 | ~200–400 | composite-adjunction mate recognition (bespoke) | Un-park trigger: resume as ONE mechanical lane once GF base case + SNAP scaffold land (≈ iter 050), or sooner if a lane frees. `keystoneAdjR`/`keystoneBeta`/`huce` axiom-clean; residual = large structurally-known φ/ψ Spec-layer transport. Off critical path (blocks nothing) but goal-required. |
| FBC-A2 — affine/locality reduction | ACTIVE | 3–6 | ~200–500 | locality-of-`IsIso` on a basis (Mathlib-absent) | Parallelisable, independent of A1; blueprint EXISTS. Consult then prover. |
| FBC-B — globalization, H⁰-equalizer | gated on A1 iso | 2–5 | ~100–260 | `tensorEqLocusEquiv`; sheaf fork | eqLocus payoff DONE; `FlatBaseChangeGlobal.lean` needs scaffold; completion gated on A1. |
| GF-geo — `genericFlatness` | ACTIVE | 2–4 | ~150–300 | `Module.flat_of_isLocalized_span` (verified); source-localization-preserves-flatness (Mathlib-GAP — build) | G1 DONE; G3 pure-algebra anchors DONE (G3.1/G3.3/G3.4). Blueprinted **stalk route DEAD** (no `SheafOfModules.stalk` in Mathlib). Re-spec around **source-span descent**: algebraic brick `gf_flat_localizedModule_sameBase` + geometric `Γ(F,D(g))≅(M_j)_g` feeding `flat_of_isLocalized_span`. ~2–3 iter descent build. |
| QUOT-defs consumers — annihilator / P2 | ACTIVE (annihilator frontier-ready) | 1–3 | ~80–200 | annihilator engine + gap2 (both DONE) | All `lem:modules_annihilator_ideal` deps done → BUILD `annihilator_ideal`. P2 predicate defined. QuotScheme.lean; 4 stubs protected. |
| SNAP — `def:sectionGradedRing` tensor-powers | ACTIVE | 4–8 | ~300–600 | `PresheafOfModules.Monoidal` + `Sheaf.monoidalCategory` (PRESENT) wired to `SheafOfModules`; lax-monoidal `Γ` | Monoidal scaffold EXISTS in Mathlib (reuse, don't re-derive); calibrate vs GradedHilbertSerre 9it/1290LOC. Required to STATE `def:hilbert_polynomial`. Chapter ready → scaffold `SectionGradedRing.lean`. |
| SNAP-S1/S3 — section-module input + `Φ_s` extraction | BLOCKED | 3–6 | ~150–400 | `existsUnique_hilbertPoly` | GATED on Open Q1 + the `def:sectionGradedRing` row above. |
| QUOT-repr — `thm:grassmannian_representable` | BLOCKED | 6–12 | ~400–1000+ | Grassmannian-of-quotients as a scheme; RelativeSpec → `RepresentableBy` | deepest target; GR-cells/glue/sep DONE; quot/repr in Routes |

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|---|
| GF-alg — algebraic core | 022 · ~9 | ~900 | FlatteningStratification.lean | `genericFlatnessAlgebraic` axiom-clean (Nitsure §4 dévissage); L4/L5 | `g:=g0·g1`; ring↔module bridge `IsLocalizedModule.iso` + `extendScalarsOfIsLocalization`; base-generalizing strong induction | `letI`-built `Algebra A Cg` is `isDefEq` dead end (use ambient); deep stack needs `maxHeartbeats 1600000` |
| FBC RegroupHelper | 011 · 4 | ~120 | Cohomology_RegroupHelper | `regroupEquiv` `(A⊗_R R')⊗_A M ≅ R'⊗_R M` axiom-clean | `eT` identity-bridge + `TensorProduct.induction_on` to beat transparent-instance diamonds | element `map_smul'` zero-branch needed `erw [TensorProduct.zero_tmul]` |
| GR-cells (charts+cocycle) | 012 · 2 | ~600 | GrassmannianCells.lean | big-cell charts, transition maps, `lem:gr_cocycle` — 28 decls | `IsLocalization.Away.lift` for localized transition maps; prove distributed-matrix forms by `exact` then `rw` | `rw [Matrix.map_mul]` fails on Away-base-changed matrices (hidden `algebraMap` diamond) |
| GR-glue + separated | 034 · 4 | ~350 | GrassmannianCells.lean | `Grassmannian.scheme` (GlueData), `isSeparated`/`isSeparatedToSpecZ`, `diagonalRingMap_surjective` | `Spec ℤ` genuinely terminal for `Scheme.{0}` ⟹ `toSpecZ` + glue by `IsTerminal.hom_ext`; faithful `Proj.isSeparated` port (per-patch closed immersion) | `convert!`/`pullback.map_fst` absent (use `convert … using 1`, `pullback.lift_fst`); `← Spec.map_comp` bare `rw` dead on the Scheme-cat diamond (route via `show`) |
| SNAP-S2 power-series engine | 012 · 1 | ~180 | QuotScheme.lean (`IsRatHilb`) | antidifference + `IsRatHilb.ofDiffEq` (power-series half of Stacks 00K1), 8 decls | telescoping via `invOneSubPow`; `IsRatHilb` predicate isolates series bookkeeping | `PowerSeries.C` ring arg implicit; `open … in` must precede docstring |
| SNAP-S2 graded Hilbert–Serre rationality | 020 · 9 | ~1290 | GradedHilbertSerre.lean | keystone `gradedModule_hilbertSeries_rational` (Stacks 00K1) axiom-clean | Route-2 ambient-subquotient pairs (`Naux⊓ℳn`) sidestep quotient-carrier gradings | bundled `DirectSum.Decomposition`/`IsInternal` over quotient/subtype carrier is a hard `isDefEq` dead end (Route 2 supersedes) |
| QUOT-defs P1 predicates | 011 · 1 | ~90 | QuotScheme.lean | schematic-support, proper-support via `IdealSheafData.ofIdeals`/`.subscheme` | annihilator-ideal-sheaf needs NO QCoh bridge | — |
| GR-proper — valuative criterion | 038 · ~5 | ~300 | GrassmannianCells.lean | `Grassmannian.isProper` (Gr(d,r) proper over ℤ); E4/E5/existence-lift | Nitsure §1 DVR-filler (minimal minor J, factor through R⊂K); term-mode glue for Spec.map composition | keyed `rw` dead on Scheme-cat diamond (use `congrArg`/`calc`); `existence_lift` noncomputable; pass `(R:=S.R)` to E2/E3 |
| QUOT gap1 — section-loc descent | 041 · ~14 | ~600 | QuotScheme.lean | gap1 `isIso_fromTildeΓ_of_isQuasicoherent` + keystone `isLocalizedModule_basicOpen_descent` + `Hfr` producer (Hartshorne II.5.3), WITHOUT global QCoh≃Mod | keep immersion `j` OPAQUE in helpers; σ `S`-vs-`Γ(Spec S,⊤)` rebasing is `rfl` | concrete `j` → >3.2M-heartbeat `whnf` runaway; general-U `_of_cover` `Hfr` is an unprovable trap (use basic-open) |
| QUOT gap2 — qcoh section-localization on basic opens | 044 · ~3 | ~520 | QuotScheme.lean | `isLocalizedModule_basicOpen` + Piece A `isQuasicoherent_pullback_fromSpec` (L1–L6) + Piece B eqToHom bridge | QC-under-pullback via equivalence-transport (`overRestrictUnitIsoInv`); open-imm pullback-unit Final via open-map adjunction; `.IsQuasicoherent` dot-notation | gateway `↥V`/`↥↑V` coercion + IsContinuous non-synth = dead route; bypass via equivalence-transport |

## Routes

Single route per target; the leg is a fan of independent leaves merging back upstream. FBC-A, GF-geo,
and QUOT-consumers are the live frontier. FBC-B follows FBC-A; QUOT-repr follows QUOT-defs + SNAP.

**FBC route.** The affine lemma `g^* f_* F ≅ f'_* g'^* F` (Stacks 02KH part 2) reduces at the module
level to `regroupEquiv` (DONE). Two obligations: **(1) affine reduction** (`base_change_map_affine_local`,
blueprint present) and **(2) the section-level identity** for the parent-frozen canonical map.
- *Obligation 2 — section mate, crux = keystone `_legs_conj`.* No element-level bypass exists: in the
  affine square `g' = pullback.fst` has no element normal form, so any section read of `Γ(α)` is the
  conjugate intertwining (both the conjugate calculus and the affine tilde-transport attempt funnel here;
  element-`ext` also dead). The three per-layer legs (conj-2b/2c/2d) are axiom-clean.
- *Keystone discharge — factored route.* Build the composite adjunctions `adjL`/`adjR` as nested
  `Adjunction.comp`, then discharge `_legs_conj` as a chain of the three axiom-clean legs via
  `conjugateEquiv_symm_comp` + `conjugateEquiv_whiskerLeft/Right` (mirroring Mathlib's
  `leftAdjointCompNatTrans₀₂₃_eq_conjugateEquiv_symm`) — NOT a monolithic `β` (the abandoned trap that
  walled the one-shot approach). Recipe: `analogies/fbc-composite-mate-recognition.md`. Off critical path
  (blocks no other route).

Globalize **Čech-cohomology-free**: `H⁰(X,F)` is the equalizer `∏Γ(Uᵢ,F) ⇉ ∏Γ(Uᵢⱼ,F)`, and flat `−⊗B`
preserves that finite equalizer (`tensorEqLocusEquiv`).

**GF route.** Algebraic core `genericFlatnessAlgebraic` DONE (Nitsure §4). Geometric `genericFlatness`
(`[IsQuasicoherent]`+`[IsFiniteType]`) wraps it: pass to affine `Spec A ⊆ S` (noetherian domain), cover
`p⁻¹(Spec A)` by finite affine `W_j = Spec B_j` (finite-type/A), read `M_j = Γ(F,W_j)` finite over `B_j`
(via G1 — **DONE**), apply the algebraic form per patch, conclude flatness over `V = D(∏ f_j)`. G3 promotes
per-patch freeness `(M_j)_f` free/`A_f` to flatness of section modules `Γ(F,W)/Γ(S,U)` for arbitrary
affine `W ≤ p⁻¹U`. Pure-algebra anchors DONE: G3.1 `gf_patch_free_imp_flat` (`Module.Flat.of_free`),
G3.3 `gf_flat_base_local_on_source` (`Module.flat_of_isLocalized_maximal`), G3.4 `gf_stalk_flat_localBase`
(localized-base transitivity).
- *Stalk route DEAD.* The blueprinted assembly routed section-flatness through sheaf-module **stalks** `F_x`;
  Mathlib has **no `SheafOfModules.stalk`** (loogle 0) — G3.2 + assembly cannot even be typed. Confirmed dead
  end, NOT effort-blocked.
- *Re-spec = source-span descent.* Close `Module.Flat Γ(S,U) Γ(F,W)` via the **source-side** span criterion
  `Module.flat_of_isLocalized_span` [verified, `RingTheory.Flat.Localization`] on a finite basic-open cover
  `{D(g) ⊆ W ∩ W_j}` aligned to the patches, using two bridges: **(B1, algebraic, Mathlib-GAP)**
  `gf_flat_localizedModule_sameBase : [Module.Flat R N] → Module.Flat R (LocalizedModule T N)` for
  `T : Submonoid B` over the tower `R→B→N` (localization commutes with `lTensor`, exact); **(B2, geometric)**
  chart-independent section-localization `Γ(F,D(g)) ≅ (M_j)_g` (QC-module sheaf condition) + base-ring
  comparison `Γ(S,U)`⟂`A_f`. B1 is a self-contained Mathlib-gradient lemma (dispatch now); B2 + assembly
  ride on it.

**QUOT route.** Foundational decisions:
- *Hilbert-poly encoding = graded Hilbert function.* `def:hilbert_polynomial` = `Φ_s` agreeing for `m≫0`
  with `m ↦ dim_{κ(s)} Γ(X_s, F_s ⊗ L_s^m)` (Hartshorne I.7.5; Nitsure §1), via
  `Polynomial.existsUnique_hilbertPoly` (`[CharZero]`) + `lem:gradedHilbertSerre_rational` (DONE).
- *Rationality engine = Route 2* (Stacks 00K1 over pairs `N'≤N` in a fixed ambient graded κ-module). DONE.
- *SNAP-S1 input* (GATED — Q1): chosen f.g. presentation — every coherent `F` on `Proj S` is `M̃` for a
  f.g. graded `M`, sidestepping the doubtful "Γ_*(F) f.g." lemma.
- *QUOT-defs*: P1 support predicates DONE; gap1 DONE; consumers (G1-core/gap2/annihilator) + P2 NEXT.
  `Grassmannian := QuotFunctor (𝟙 S) V Φ_d`.
- *QUOT-repr decomposed*: GR-cells/glue/separated/proper (DONE); GR-quot (tautological rank-`d` quotient +
  universal property); GR-repr (functor-of-points ⟹ `RepresentableBy` via `thm:relative_spec_univ`).

## Open strategic questions

- **Q1 — SNAP route DECISION (blocks S1).** Canonicity of `Φ_s`: either (a) chosen-presentation `Φ_s` + a
  cited Serre `m≫0` agreement, or (b) H¹-free finiteness with a reference. gap1 now closed ⟹ trigger active:
  dispatch a reference-retriever for the Serre `m≫0` agreement (the "Hartshorne II.5.17" attribution is
  unverified/likely wrong), then decide (a) vs (b). `def:sectionGradedRing` tensor-powers owed regardless.
- **Q2 — FBC keystone `_legs_conj` discharge — ROUTE DECIDED (factored, not monolithic).** See FBC route;
  `adjL`/`adjR`/`β` built, residual = mechanical transport. Off critical path; not escalated (autonomous).
- **Q3 — `def:hilbert_polynomial` standard-graded hypothesis (fence before any SNAP/S1 prover).** Stacks
  00K1 needs `S₊` generated in degree 1 ⟹ the def must carry a standard-graded/very-ample hypothesis
  (ample-only insufficient). Verify the Lean signature carries it before S1.
- **Q4 — RelativeSpec Stacks-tag pin (fence before QUOT-repr).** `thm:relative_spec_univ` underpins GR-repr;
  `references/summary.md` flags tag uncertainty (01LL is a §-label, 01LO is transitivity not the affine
  case, 01LR is the defining eqn — real targets likely 01LM/01LP/01LT). Reference-retrieve + pin the
  affine-base-change tag before any QUOT-repr prover.
- **Merge-back signature check.** Confirm re-signed `genericFlatness`/QUOT decls match the parent cone.

## Mathlib gaps & new material

Gaps to fill (detail in Routes):
- FBC-A: keystone `_legs_conj` via composite adjunctions `adjL`/`adjR` + the `conjugateEquiv_symm_comp`
  leg-chain (no new Mathlib lemma; the conjugate API exists).
- GF-geo: **G3 close** via source-span descent (stalk route dead). Algebraic brick (Mathlib-GAP)
  `gf_flat_localizedModule_sameBase`: source-localization of an `R`-flat module is `R`-flat (build via
  `lTensor`-localization commute + exactness). Then geometric `Γ(F,D(g))≅(M_j)_g` descent + the verified
  `Module.flat_of_isLocalized_span`. (G1 base case + G3 pure-algebra anchors all DONE.)
- **gap1 (QCoh≃Mod affine descent), G1-core, gap2 (`isLocalizedModule_basicOpen`): all DONE** (see
  `## Completed`). gap2 → annihilator characterization (frontier-ready) + GF-G1 locality (DONE).
- **SheafOfModules tensor powers (blocks `def:sectionGradedRing` ⟹ SNAP):** wire Mathlib's existing
  `PresheafOfModules.Monoidal` + `Sheaf.monoidalCategory` through to `SheafOfModules` over the scheme
  (reuse, don't re-derive) + lax-monoidal `Γ`; Mathlib-gradient sub-build owed before SNAP.
- QUOT predicates: rank-`r` local-freeness for `SheafOfModules`. QUOT-repr: Grassmannian-of-quotients as
  a scheme (Nitsure §1/§5 big-cell patching).

New project material:
- `genericFlatnessAlgebraic` (done); re-signed `genericFlatness` + coherence encoding
  (`[IsQuasicoherent]`+`[IsFiniteType]` over a locally noetherian base).
- QUOT defs with tightened signatures; `Grassmannian` via `QuotFunctor`; representability as `IsRepresentable`.
```

## references/summary.md (index)
```
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
| [`stacks-properties.md`](./stacks-properties.md) → `stacks-properties.tex` | Stacks ch. "Properties of Schemes" (5424 lines). **Tag 01PB** = `lemma-finite-type-module` (lines 2092–2110, §"Characterizing modules of finite type and finite presentation", tag 01PA at line 2075): `M̃` is finite-type iff `M` is finite `R`-module. Also **tag 01B5** = `modules-definition-finite-type` (in modules.tex, lines 809–817): the base definition of finite-type O_X-module. Backs `lem:gf_qcoh_fintype_finite_sections` in `Picard_FlatteningStratification.tex`. Use `Read offset:2092 limit:19`. **Tag `lemma-invert-f-sections`** (`\label` at line 2153, §"Sections over principal opens"): for a qcqs scheme `X` and `f ∈ Γ(X,𝒪_X)`, `Γ(X,ℱ)_f ≅ Γ(X_f,ℱ)` for quasi-coherent `ℱ` (= Hartshorne II.5.3) — backs the gap1 keystone D `lem:section_localization_descent` in `Picard_QuotScheme.tex`. Use `Read offset:2150 limit:24`. |
| [`stacks-modules.md`](./stacks-modules.md) → `stacks-modules.tex` | Stacks ch.17 "Sheaves of Modules" (5939 lines). **§17.16 Tensor product** (tag **01CA**, line 2271): inline definition of `F ⊗_{O_X} G` as sheafification of presheaf `U ↦ F(U)⊗_{O_X(U)}G(U)` at lines 2282–2296; lemmas 01CB (stalk-iso), 01CC (right-exact), 01CD (pullback). **§17.25 Invertible modules** (tag **01CR**, line 4038): definition-invertible 01CS (line 4047), definition-powers 01CU (line 4220, L^{⊗n}), definition-gamma-star 01CV (line 4269, Γ_*(X,L)=⊕_{n≥0}Γ(X,L^{⊗n}) and Γ_*(X,L,F)=⊕_n Γ(X,F⊗L^{⊗n})). Backs `Picard_SectionGradedRing.tex`. Use `Read offset:<line> limit:<n>`. |
```

## Blueprint chapter topic map (title only)
- Cohomology_FlatBaseChange: flat base change for pushforward of QC sheaf (i=0) [FBC]
- Cohomology_RegroupHelper: regrouping iso for affine base-change tensor tower [FBC support]
- Picard_FlatteningStratification: flattening stratification / generic flatness [GF]
- Picard_GrassmannianCells: the Grassmannian over Z (charts/glue/proper) [QUOT-repr, DONE]
- Picard_GrassmannianQuot: tautological quotient + universal property of Gr [QUOT-repr]
- Picard_QuotScheme: the Quot scheme (Hilbert poly, quot functor, gap1/gap2) [QUOT]
- Picard_RelativeSpec: relative Spec [QUOT-repr support]
- Picard_SectionGradedRing: section graded ring infra — tensor powers + graded sections [SNAP]

## Output
SOUND / CHALLENGE / REJECT per route. Specifically rule on the new GF source-span re-spec.
