# strategy-critic directive — iter-029

Verify the strategy is sound as a fresh mathematician would: challenge route choices, decomposition, and any sunk-cost momentum. STRATEGY.md changed this iter (FBC-A estimate revised, QUOT G1-core reduced to a single gap1 lemma + sub-build, FBC route prose corrected to route Seam A through `_legs`).

## Project goal

Close the sorry-bearing nodes of the **Čech-independent leg** of the parent's `thm:fga_pic_representability` cone (Kleiman FGA "The Picard scheme" §4): flat base change at i=0 (FBC), generic flatness (GF), and the Quot/Grassmannian foundations (QUOT). End-state: zero project sorry in the closure, zero project axioms, kernel-only axioms; names/labels match the parent so finished work merges back.

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

End-state: zero project `sorry` in the 29-node closure, zero project axioms, kernel-only axioms.
Names/labels are the parent's so finished work merges back into its A.2.c engine.

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| FBC-A — affine lemma, direct-on-sections | ACTIVE | 1–2 (was OVER_BUDGET: entered iter-018, est 2–4, 10+ elapsed; now revised down — the diamond mechanism is concrete) | ~60–150 | proved tilde dictionaries; `conjugateEquiv_counit_symm`, `Adjunction.comp_counit_app` | gstar 5-lemma chain: Seams B/C DONE; literal-form lock BROKEN. `X.Modules` instance-diamond (composed-⋙ vs nested-obj `Functor.map` domain) blocked the `_legs` assembly 1 iter — RESOLVED by the **term-mode mechanism** (`congrArg`/`Functor.congr_map`/`.trans`/`exact`; abandon `hpfc`, splice the SHIPPED eCancel atoms; analogist iter-029 + 3 in-file precedents `pullbackPushforward_unit_comp`/`gammaDistribute`/`eCancel_pushforwardComp`). Same mechanism unblocks `gstar_transpose` |
| FBC-B — globalization, H⁰-equalizer | NEXT | 2–5 | ~120–300 | `Mathlib.RingTheory.Flat.Equalizer`; finite affine cover + sheaf condition for `SheafOfModules` | flat-equalizer half Mathlib-backed; residual = H⁰-as-equalizer packaging. In-closure (`@1755 affineBaseChange`, `@1795 flatBaseChange`), sequenced after gstar |
| GF-geo — `genericFlatness` | ACTIVE | 2–4 (revised up; G1/G3 are real Mathlib-absent plumbing, not 1-iter wrappers) | ~120–300 | algebraic core (done); `Module.flat_of_isLocalized_maximal`; `LocallyOfFiniteType.finiteType_appLE`; G1/G3 are project-built | base `[IsIntegral S]` present (✓, else false); `[QuasiCompact p]` added (was false without it). Two genuine missing-Mathlib bridges: **G1** qcoh+finite-type ⟹ Γ(F,W) finite over Γ(X,W); **G3** flat-locality assembly. G1 bottoms at the shared keystone `isLocalizedModule_basicOpen` (built QUOT-side, see Open questions) — GF-G1 dispatch deferred until that lands |
| GR-glue — `Grassmannian.scheme` by gluing charts | ACTIVE | 1–3 | ~120–320 | `Scheme.GlueData`/`Multicoequalizer`; charts+transitions+cocycle (DONE) | self-contained, NO keystone dep; cocycle DONE; build glued scheme → separated → proper. The one fully-unblocked lane |
| QUOT-defs — Quot/Grassmannian defs + predicates | ACTIVE (infra-gated) | 4–8 | ~220–560 | QCoh≃Mod affine descent; SheafOfModules tensor powers | G1-core/gap1 now reduced (iter-028) to ONE lemma `isIso_fromTildeΓ_of_isQuasicoherent` (all glue + 3 IsLocalizedModule fields already in-file); irreducible content = the gap1 sub-build `exists_isIso_fromTildeΓ_basicOpen_cover` (finite basic-open tilde cover from `QuasicoherentData`, Stacks 01HA) + Mayer–Vietoris induction — the mathlib-build target this iter. `sectionGradedRing` blocked on SheafOfModules tensor powers; annihilator gated on gap1; SNAP gated on Serre; 4 stubs protected |
| SNAP-S1/S3 — section-module input + `Φ_s` extraction | NEXT | 3–6 | ~150–400 | `SheafOfModules` tensor powers of `L_s`; `existsUnique_hilbertPoly` | **GATED**: the f.g. input may carry irreducible Serre content — see Routes/Open questions |
| QUOT-repr — `thm:grassmannian_representable` | BLOCKED | 6–12 | ~400–1000+ | Grassmannian-of-quotients as a scheme; RelativeSpec → `RepresentableBy` | deepest target; GR-cells DONE; GR-glue/quot/repr in Routes |

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|---|
| GF-alg — algebraic core | 022 · ~9 | ~900 | FlatteningStratification.lean | `genericFlatnessAlgebraic` axiom-clean (Nitsure §4 dévissage); L5 polynomial core, L4 Noether denominator-clearing, L4 injectivity all axiom-clean | `g:=g0·g1` + `IsIntegral.exists_multiple_integral_of_isLocalization`; ring↔module bridge `IsLocalizedModule.iso` + `LinearEquiv.extendScalarsOfIsLocalization`; strong induction generalizing the base domain | hand-built `Algebra A Cg` via `letI` is an `isDefEq` dead end (use ambient instances); deep stack needs `maxHeartbeats 1600000` |
| FBC RegroupHelper | 011 · 4 | ~120 | Cohomology_RegroupHelper | `regroupEquiv` `(A⊗_R R')⊗_A M ≅ R'⊗_R M` axiom-clean | `eT` identity-bridge + `TensorProduct.induction_on` to beat transparent-instance diamonds | element `map_smul'` zero-branch needed `erw [TensorProduct.zero_tmul]` |
| GR-cells (charts+cocycle) | 012 · 2 | ~600 | GrassmannianCells.lean | big-cell charts, transition maps, `lem:gr_cocycle` — 28 decls | `IsLocalization.Away.lift` for localized transition maps; prove distributed-matrix forms by `exact` then `rw` | `rw [Matrix.map_mul]` fails on Away-base-changed matrices (hidden `algebraMap` diamond) |
| SNAP-S2 power-series engine | 012 · 1 | ~180 | QuotScheme.lean (`IsRatHilb`) | antidifference + `IsRatHilb.ofDiffEq` (power-series half of Stacks 00K1), 8 decls | telescoping via `invOneSubPow`; `IsRatHilb` predicate isolates series bookkeeping | `PowerSeries.C` ring arg implicit; `open … in` must precede docstring |
| SNAP-S2 graded Hilbert–Serre rationality | 020 · 9 | ~1290 | GradedHilbertSerre.lean | keystone `gradedModule_hilbertSeries_rational` (Stacks 00K1) axiom-clean | Route-2 ambient-subquotient pairs (`Naux⊓ℳn`) sidestep quotient-carrier gradings; ROUTE (b) base case | bundled `DirectSum.Decomposition`/`IsInternal` over quotient/subtype carrier is a hard `isDefEq` dead end (Route 2 supersedes) |
| QUOT-defs P1 predicates | 011 · 1 | ~90 | QuotScheme.lean | schematic-support, proper-support via `IdealSheafData.ofIdeals`/`.subscheme` | annihilator-ideal-sheaf needs NO QCoh bridge | — |

## Routes

Single route per target; the leg is a fan of independent leaves merging back upstream. FBC-A and
GF-geo are the live frontier; QUOT is authorable in parallel (all four files import only Mathlib).
FBC-B follows FBC-A; QUOT-repr follows QUOT-defs, SNAP, and the RelativeSpec strengthening.

**FBC route.** Prove the affine lemma **directly on global sections** (Stacks 02KH part 2). Rewrite
both sides through the proved tilde dictionaries (`pullback_spec_tilde_iso`,
`pushforward_spec_tilde_iso`); the regroup iso `(A⊗_R R')⊗_A M ≅ R'⊗_R M` (`regroupEquiv`) is closed
axiom-clean. The section identity is a **domain read + codomain read + g^*-transpose** triangle:
`section_identity = domain_read⁻¹ ≫ (base-change map) ≫ codomain_read = regroupEquiv⁻¹`, with
`domain_read`/`codomain_read` both axiom-clean. The live crux is **Seam 3 gstar_transpose** (the
`(g^* ⊣ g_*)`-counit coherence). It is now a 5-lemma chain: Seam A inner value `Γ_R(θ_in) = ρ`
(`inner_unitReduce → inner_eCancel → inner_value_eq`), Seam B generator close, Seam C counit transport
(the proven `conjugateEquiv_counit_symm` master identity, dual of Seam-1 `unit_value`). Seam A is
realised THROUGH the leg-parametrised `fstar_reindex`/`fstar_reindex_legs` (post-subst, leg =
`e ≫ Spec ιA` definitionally) — NOT inline at the projection legs (that route is WALLED: dependent-motive
obstruction, confirmed iter-026). The `_legs` step-(iii) eCancel assembly is closed by the **term-mode
mechanism** (`congrArg`/`Functor.congr_map`/`.trans`/`exact` splicing the SHIPPED eCancel atoms — NOT
keyed `rw`/`simp`/`erw`, which the `X.Modules` instance diamond defeats). Globalize the i=0 statement
**Čech-cohomology-free**: `H⁰(X,F)` is the equalizer `∏Γ(Uᵢ,F) ⇉ ∏Γ(Uᵢⱼ,F)` (sheaf condition, Čech
degree 0/1 — NOT cohomology), and a flat `−⊗B` preserves that finite equalizer
(`Module.Flat.{ker,eqLocus}_lTensor_eq`).

**GF route.** Algebraic core `genericFlatnessAlgebraic` is DONE (see Completed): Nitsure §4 variable-count
induction with base-domain generalization. Geometric `genericFlatness` (re-signed with
`[IsQuasicoherent]`+`[IsFiniteType]`) wraps it: pass to a non-empty affine open `Spec A ⊆ S` (A a
noetherian domain), cover `p⁻¹(Spec A)` by finitely many affine `W_j = Spec B_j` (each finite-type over
A by `LocallyOfFiniteType`), read `M_j = Γ(F,W_j)` finite over `B_j` (from `IsFiniteType`), apply the
algebraic form per patch to get `f_j ≠ 0`, take the common basic open `V = D(∏ f_j)`, and conclude
flatness from freeness over the localisation (flat-at-every-maximal criterion).

**QUOT route.** Decisions taken to resolve the foundational dependencies:

- *Hilbert-polynomial encoding = graded Hilbert function.* `def:hilbert_polynomial` is the polynomial
  `Φ_s` agreeing for `m≫0` with the graded Hilbert function `m ↦ dim_{κ(s)} Γ(X_s, F_s ⊗ L_s^m)` of a
  f.g. graded module over the homogeneous coordinate ring (Hartshorne I.7.5; Nitsure §1). Polynomiality
  routes through (i) `Polynomial.existsUnique_hilbertPoly` (extraction half, `[CharZero]`) and (ii) the
  graded Hilbert–Serre RATIONALITY step `lem:gradedHilbertSerre_rational` — **DONE, axiom-clean**
  (keystone `gradedModule_hilbertSeries_rational`, Route 2 ambient-subquotient induction). This yields
  the same polynomial as the cohomological χ without higher cohomology.
- *Rationality engine = Route 2.* Run the Stacks-00K1 induction over **pairs of homogeneous submodules
  `N'≤N` of a single FIXED ambient graded κ-module `M`** with `r` commuting degree-+1 endomorphisms;
  Hilbert function = ambient difference `n ↦ dim_κ(N⊓ℳn) − dim_κ(N'⊓ℳn)`. Closed under ker/coker of a
  degree-1 endo (both ambient subquotient pairs), so no derived-carrier graded object is ever formed —
  avoids the quotient-carrier `isDefEq` pathology. `DirectSum.Decomposition.ofLinearMap` is the
  documented fallback for any genuine future derived-carrier graded object.
- *SNAP-S1 = the f.g.-graded-module input (GATED — see Open questions).* The Hilbert polynomial needs a
  f.g. graded module whose degree-`m` dimension matches `Γ(F_s ⊗ L_s^m)`. **Primary route: chosen f.g.
  presentation.** Every coherent `F` on `Proj S` is `M̃` for some f.g. graded `S`-module `M` (the
  surjectivity half of `M ↦ M̃`, a chapter-II construction — `M` is f.g. *by construction*). Apply the
  rationality engine + `existsUnique_hilbertPoly` to that `M`. This gets finite generation for free,
  sidestepping the doubtful "Γ_*(F) f.g." lemma. **Caveat:** making `Φ_s` a canonical invariant of `F`
  (independent of the chosen `M`) needs the `m≫0` agreement across presentations, i.e. a Serre-type
  input — so the QUOT Hilbert-polynomial sublane is **NOT unconditionally Čech-independent**; some
  Serre `m≫0` agreement appears genuinely required (Quot stratifies by Hilbert polynomial ⟹ `Φ` must be
  canonical). Resolve before building S1: confirm whether the parent cone needs `Φ` canonical, and
  produce/cite an *exact* result for the finiteness used (the "Hartshorne II.5.17" attribution is
  unverified and likely wrong). Needs `def:sectionGradedRing`.
- *QUOT-defs predicate sub-builds* (encoding-independent): P1 schematic-support + `IsProper` DONE; P2
  rank-`r` local-freeness predicate for `SheafOfModules` NEXT. Both gate faithful re-signs of the four
  stubs. `Grassmannian := QuotFunctor (𝟙 S) V Φ_d`. The forward annihilator characterization is
  bridge-gated on `lem:qcoh_section_localization_basicOpen` (QCoh→`IsLocalizedModule`); its sole
  consumer is QUOT-repr's support check (BLOCKED). iter-028 established (source-grep verified) that this
  bridge ≡ gap1 ≡ the single lemma `isIso_fromTildeΓ_of_isQuasicoherent`; the local/stalk shortcuts do
  NOT avoid it. Route = the gap1 sub-build `exists_isIso_fromTildeΓ_basicOpen_cover` (finite basic-open
  tilde cover from `QuasicoherentData`) then `isIso_fromTildeΓ_of_isLocalizedModule_restrict`.
- *QUOT-repr decomposed*: GR-cells (DONE); GR-glue (Plücker cocycle gluing + separatedness via the
  diagonal); GR-quot (tautological rank-`d` quotient + universal property); GR-repr (functor-of-points
  ⟹ `RepresentableBy`). GR-repr needs `thm:relative_spec_univ` strengthened to `RepresentableBy` via
  `representableByEquiv` (verified present) — re-opening the two RelativeSpec proofs is in QUOT-repr scope.

## Open strategic questions

- **QUOT S1 finiteness / Serre content (must resolve before building S1).** Does the parent cone consume
  `def:hilbert_polynomial` as a canonical invariant of `F`? If yes, canonicity needs an `m≫0` agreement
  across graded presentations (Serre-type), so the sublane is not unconditionally Čech-independent. Pick:
  (a) chosen-presentation `Φ_s` + an explicit, cited Serre `m≫0` agreement, or (b) a genuinely H¹-free
  finiteness with an *exact* reference. Verify the "Hartshorne II.5.17" attribution (likely wrong) via
  a reference read before any S1 prover.
- FBC merge-back necessity: does the parent consume `lem:affine_base_change_pushforward` as "the canonical
  map is iso" (⟹ Seam 3 unavoidable) or "∃ natural iso" (⟹ `regroupEquiv` suffices)? The gstar route is
  structurally advancing (step-1 + scaffold landed, now a 5-lemma chain), so continue it; revisit only if
  the chain stalls ≥2 iters.
- Merge-back signature check: confirm the re-signed `genericFlatness`/QUOT decls
  (`[IsQuasicoherent]`+`[IsFiniteType]`) match the parent cone's expected signatures.
- **Shared qcoh-affine-local infra (GF-G1 ∩ QUOT) — keystone identified.** GF-G1 (`Γ(F,W)` finite on
  affine) and QUOT (`lem:qcoh_section_localization_basicOpen` = annihilator reverse direction + section
  graded module) both bottom out at the SAME node: the qcoh affine-local identification
  `isLocalizedModule_basicOpen` (sections of a quasi-coherent `M̃` on `D(f)` are `M(U)` localized at
  `powers f`). It has no Lean decl yet. **Decision (iter-024):** build it ONCE in QuotScheme.lean (its
  `\lean{}` namespace `Scheme.Modules.*` + blueprint home + a live QUOT consumer), NOT a self-contained
  copy in FlatteningStratification (that would be the parallel-API mistake the PARALLELISM directive warns
  against, and FlatteningStratification does not import QuotScheme). GF-G1/G3 consume it afterwards — once
  it lands, decide shared-extraction vs adding the QuotScheme import to FlatteningStratification (a
  mathlib-analogist API-alignment pass gates that). Part (1) is the Mathlib anchor
  `IsAffineOpen.isLocalization_basicOpen`; the substance is part (2), transporting the Spec-local
  `Γ(D(f),Ñ)=N_f` fact to a general quasi-coherent sheaf via `U ≅ Spec Γ(X,U)`.

## Mathlib gaps & new material

Gaps to fill (detail in Routes):
- FBC-A: section-level inner value `Γ_R(θ_in) = ρ` chain + counit-transport coherence + regroup diamond.
- FBC-B: H⁰-as-equalizer / finite-affine-cover sheaf-condition packaging for `SheafOfModules`.
- GF-geo: **G1** (qcoh+finite-type ⟹ `Γ(F,W)` finite over `Γ(X,W)` on affine `W`; the qcoh affine-local
  identification `F|_W ≅ Ñ` with finiteness preserved — Mathlib-absent, project-built) and **G3**
  (flat-locality assembly: per-patch freeness on a finite source cover ⟹ flatness over `Γ(S,U)`). G1 is
  the keystone and overlaps the QUOT `lem:qcoh_section_localization_basicOpen` node — extract to shared
  qcoh-affine-local infra once both consumers are concrete (see Open questions).
- **QCoh≃Mod affine descent (gap1, keystone bottom):** `IsQuasicoherent M → IsIso M.fromTildeΓ` on
  `Spec R` (`lem:qcoh_affine_isIso_fromTildeΓ`). Mathlib has `isIso_fromTildeΓ_iff` + the global-
  `Presentation` case (`isIso_fromTildeΓ_of_presentation`) only; the local-presentations ⟹ global-
  presentation globalization on the affine is Mathlib-absent. The two affine engines
  (`isLocalizedModule_tilde_restrict`, `…_restrict_of_isIso_fromTildeΓ`) are DONE; closing gap1 makes
  the affine-QC keystone immediate. **mathlib-build target this iter.**
- **SheafOfModules tensor powers (gap, blocks `def:sectionGradedRing` ⟹ SNAP):** `L_s^{⊗m}` tensor
  powers of a line bundle + lax-monoidal `Γ` are absent at the pinned commit; `sectionGradedRing` cannot
  be formalized until this infra is built. Mathlib-gradient sub-build, owed before SNAP.
- SNAP: chosen-presentation f.g. input + (if needed) a cited Serre `m≫0` agreement; `def:sectionGradedRing`
  (itself blocked on SheafOfModules tensor powers, above).
- QUOT predicates: rank-`r` local-freeness for `SheafOfModules`; forward annihilator char. via the QCoh bridge.
- QUOT-repr: Grassmannian-of-quotients as a scheme (Nitsure §1/§5 big-cell patching).

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

## Blueprint chapters (title + one-line topic)

- Cohomology_FlatBaseChange.tex — Flat base change for pushforward of a QC sheaf (i=0); the gstar/Seam chain + globalization.
- Cohomology_RegroupHelper.tex — Regrouping iso for the affine base-change tensor tower (helper, DONE).
- Picard_FlatteningStratification.tex — Flattening stratification / generic flatness (algebraic core DONE; geometric wrapper open).
- Picard_GrassmannianCells.tex — Grassmannian affine charts + gluing (cells DONE; glued scheme in progress).
- Picard_QuotScheme.tex — The Quot scheme: Hilbert polynomial, Quot functor, Grassmannian defs, QCoh→tilde keystone (gap1).
- Picard_RelativeSpec.tex — Relative Spec (supporting; strengthening to RepresentableBy owed for QUOT-repr).
