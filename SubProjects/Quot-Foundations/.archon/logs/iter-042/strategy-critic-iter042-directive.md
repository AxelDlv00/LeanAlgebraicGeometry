# Strategy-critic — iter-042 (Quot-Foundations)

Fresh-context review of the project strategy. Below: the current STRATEGY.md verbatim, the references index, the blueprint chapter list, and the project goal. You have NO iter history — challenge the strategy as a fresh mathematician would.

## Project goal (one paragraph)

Close the sorry-bearing nodes of the Čech-independent leg of the parent's `thm:fga_pic_representability` cone (Kleiman, 'The Picard scheme', FGA §4): flat base change for the i=0 pushforward (FBC), generic flatness (GF), and the Quot/Grassmannian foundations (QUOT). End-state: zero project sorry in the 29-node closure, zero project axioms, kernel-only axioms. Names/labels match the parent's so finished work merges back.

## blueprint chapters (title / topic)
- Cohomology_FlatBaseChange.tex — Flat base change for the pushforward of a quasi-coherent sheaf (i=0)
- Cohomology_RegroupHelper.tex — Regrouping iso for the affine base-change tensor tower
- Picard_FlatteningStratification.tex — Flattening stratification / generic flatness
- Picard_GrassmannianCells.tex — The Grassmannian over Z (cells, glue, separatedness, properness)
- Picard_QuotScheme.tex — The Quot scheme (Hilbert poly, gap1 section-loc descent, predicates)
- Picard_RelativeSpec.tex — Relative Spec

## references/summary.md

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

## STRATEGY.md (verbatim)

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
| FBC-A1 — affine iso (mate `gstar_transpose`) | PIVOT (blueprint+scaffold) | 3–6 | ~150–350 | `pullback_spec_tilde_iso` (DONE); affine tilde-transport bypass | **Conjugate route EXHAUSTED in-loop** (5 iters 037–041: the multi-layer composite-adjunction recognition is a bespoke Mathlib-absent construction the prover could not assemble). Per the armed protocol NO further conjugate/analogist rounds. **New route = affine tilde-transport**: establish IsIso of the canonical `pushforwardBaseChangeMap` at the affine-local level via the proven tilde-iso, bypassing the section-level `gstar_transpose` coherence. iter-042 authors the blueprint section; scaffold + prove follow. |
| FBC-A2 — affine/locality reduction (`@2348`) | ACTIVE (parallelisable) | 3–6 | ~200–500 | locality-of-`IsIso` for `SheafOfModules` on a basis (Mathlib-absent) | Independent of A1; locality criterion + `base_change_map_affine_local` blueprint section EXIST. Consult on basis-locality then prover. Can open in parallel with the A1 tilde-transport build. |
| FBC-B — globalization, H⁰-equalizer | ACTIVE (parallel) | 2–5 | ~100–260 | `tensorEqLocusEquiv`; sheaf fork for `SheafOfModules` | eqLocus sub-lane + `baseChangeGammaEquiv` payoff DONE (axiom-clean). `FlatBaseChangeGlobal.lean` exists but UNWIRED (not imported by root) + frontier decls are TODO placeholders → needs scaffold. Chain assembly gated on FBC-A's affine iso. |
| GF-geo — `genericFlatness` | ACTIVE (UNBLOCKED by gap1) | 2–4 | ~120–300 | G1-core (now buildable); `Module.flat_of_isLocalized_maximal` | base `[IsIntegral S]`+`[QuasiCompact p]` required. G1 bottomed at gap1 (now CLOSED) — GF-G1 = direct application of G1-core; openable once G1-core lands + importable. G3 (per-patch freeness ⟹ flatness) gap1-independent but needs blueprint+scaffold + `gf_torsion_reindex` OreLocalization fix. |
| QUOT-defs consumers — G1-core / gap2 / annihilator / P2 | ACTIVE (gap1 unblocked) | 2–4 | ~120–280 | gap1 (DONE); affine-cover reduction; `SheafOfModules.free`/`pullback` | gap1 CLOSED ⟹ **G1-core** `isLocalizedModule_basicOpen_of_isQuasicoherent` (Spec R, 2-line corollary) buildable now; then **gap2** (general scheme X via affine cover) → annihilator forward inclusion. P2 (rank-`r` local-freeness predicate) gap1-independent, small. All in QuotScheme.lean; 4 iter-176 stubs protected. |
| SNAP-S1/S3 — section-module input + `Φ_s` extraction | BLOCKED | 3–6 | ~150–400 | `SheafOfModules` tensor powers of `L_s`; `existsUnique_hilbertPoly` | GATED on Open Q1 + `def:sectionGradedRing` (tensor-powers sub-build) |
| QUOT-repr — `thm:grassmannian_representable` | BLOCKED | 6–12 | ~400–1000+ | Grassmannian-of-quotients as a scheme; RelativeSpec → `RepresentableBy` | deepest target; GR-cells/glue/sep DONE; quot/repr in Routes |

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|---|
| GF-alg — algebraic core | 022 · ~9 | ~900 | FlatteningStratification.lean | `genericFlatnessAlgebraic` axiom-clean (Nitsure §4 dévissage); L4/L5 axiom-clean | `g:=g0·g1` + `IsIntegral.exists_multiple_integral_of_isLocalization`; ring↔module bridge `IsLocalizedModule.iso` + `LinearEquiv.extendScalarsOfIsLocalization`; strong induction generalizing base domain | hand-built `Algebra A Cg` via `letI` is an `isDefEq` dead end (use ambient instances); deep stack needs `maxHeartbeats 1600000` |
| FBC RegroupHelper | 011 · 4 | ~120 | Cohomology_RegroupHelper | `regroupEquiv` `(A⊗_R R')⊗_A M ≅ R'⊗_R M` axiom-clean | `eT` identity-bridge + `TensorProduct.induction_on` to beat transparent-instance diamonds | element `map_smul'` zero-branch needed `erw [TensorProduct.zero_tmul]` |
| GR-cells (charts+cocycle) | 012 · 2 | ~600 | GrassmannianCells.lean | big-cell charts, transition maps, `lem:gr_cocycle` — 28 decls | `IsLocalization.Away.lift` for localized transition maps; prove distributed-matrix forms by `exact` then `rw` | `rw [Matrix.map_mul]` fails on Away-base-changed matrices (hidden `algebraMap` diamond) |
| GR-glue + separated | 034 · 4 | ~350 | GrassmannianCells.lean | `Grassmannian.scheme` (GlueData), `isSeparated`/`isSeparatedToSpecZ`, `diagonalRingMap_surjective` | `Spec ℤ` genuinely terminal for `Scheme.{0}` ⟹ `toSpecZ` + glue by `IsTerminal.hom_ext`; faithful `Proj.isSeparated` port (per-patch closed immersion) | `convert!`/`pullback.map_fst` absent (use `convert … using 1`, `pullback.lift_fst`); `← Spec.map_comp` bare `rw` dead on the Scheme-cat diamond (route via `show`) |
| SNAP-S2 power-series engine | 012 · 1 | ~180 | QuotScheme.lean (`IsRatHilb`) | antidifference + `IsRatHilb.ofDiffEq` (power-series half of Stacks 00K1), 8 decls | telescoping via `invOneSubPow`; `IsRatHilb` predicate isolates series bookkeeping | `PowerSeries.C` ring arg implicit; `open … in` must precede docstring |
| SNAP-S2 graded Hilbert–Serre rationality | 020 · 9 | ~1290 | GradedHilbertSerre.lean | keystone `gradedModule_hilbertSeries_rational` (Stacks 00K1) axiom-clean | Route-2 ambient-subquotient pairs (`Naux⊓ℳn`) sidestep quotient-carrier gradings | bundled `DirectSum.Decomposition`/`IsInternal` over quotient/subtype carrier is a hard `isDefEq` dead end (Route 2 supersedes) |
| QUOT-defs P1 predicates | 011 · 1 | ~90 | QuotScheme.lean | schematic-support, proper-support via `IdealSheafData.ofIdeals`/`.subscheme` | annihilator-ideal-sheaf needs NO QCoh bridge | — |
| GR-proper — valuative criterion | 038 · ~5 | ~300 | GrassmannianCells.lean | `Grassmannian.isProper` (Gr(d,r) proper over ℤ); E4/E5/existence-lift | Nitsure §1 DVR-filler (minimal minor J, factor through R⊂K); term-mode glue for Spec.map composition | keyed `rw` dead on Scheme-cat diamond (use `congrArg`/`calc`); `existence_lift` noncomputable; pass `(R:=S.R)` to E2/E3 |
| QUOT gap1 — section-loc descent | 041 · ~14 | ~600 | QuotScheme.lean | gap1 `isIso_fromTildeΓ_of_isQuasicoherent` + keystone `isLocalizedModule_basicOpen_descent` + `Hfr` producer (Hartshorne II.5.3 / Stacks invert-f-sections), WITHOUT global QCoh≃Mod | keep composite immersion `j` OPAQUE in helpers; σ `S`-vs-`Γ(Spec S,⊤)` rebasing is definitional (`rfl`) | concrete triple-composite `j` → >3.2M-heartbeat `whnf` runaway in form-coercion; general-U `_of_cover` `Hfr` is an unprovable trap (use basic-open form) |

## Routes

Single route per target; the leg is a fan of independent leaves merging back upstream. FBC-A and
GF-geo are the live frontier; QUOT is authorable in parallel (all four files import only Mathlib).
FBC-B follows FBC-A; QUOT-repr follows QUOT-defs, SNAP, and the RelativeSpec strengthening.

**FBC route.** The affine lemma `g^* f_* F ≅ f'_* g'^* F` (Stacks 02KH part 2) reduces at the MODULE
level to the regroup iso `R' ⊗_R M ≅ R' ⊗_R A ⊗_A M` (`regroupEquiv`, DONE, axiom-clean). Iso-ness of
the canonical map `pushforwardBaseChangeMap` is **already free** (`conjugateIsoEquiv adjL adjR` of
`gammaPushforwardNatIso`, = `pullback_spec_tilde_iso`); the sole open work is the **coherence**
`base_change_mate_fstar_reindex_legs` / `gstar_transpose` (the canonical map's name is parent-frozen, so
the coherence is genuinely owed, not dissolvable by redefining the map). The affine close has two
obligations: **(2) the section-level identity** (the mate coherence) and **(1) the affine reduction**
(identify `(pushforwardBaseChangeMap …).app U` with the affine–affine model over the restricted square;
restriction-compatibility, Mathlib-absent). Obligation 2 (the `gstar_transpose` mate coherence) had been
pursued via the **conjugate-counit calculus**, now EXHAUSTED in-loop:
- *(CONJUGATE ROUTE EXHAUSTED — 5 iters 037–041.)* All three closing legs of `_legs_conj` are axiom-clean
  (conj-2b `pullbackLeg`, conj-2c `pushforwardCollapse`, conj-2d `crossLayer`) and iter-041 added a
  verified in-proof Γ-collapse stage, but the HEAVY crux — recognising the cross-layer composite as a
  single `conjugateEquiv` value spanning all five adjunction layers — is a bespoke, Mathlib-absent
  construction that neither the one-shot reframing (iters 037–039) nor the layer-by-layer Fallback B
  (iters 040–041) could assemble. Per the armed protocol: **NO further conjugate or analogist rounds on
  `_legs_conj`.** The proven conj scaffold (conj-1a/1b/2b/2c/2d + Γ-collapse) stays as the dictionary for
  whatever route consumes it.
- *(PIVOT — affine tilde-transport.)* The chosen next route abandons the section-level `gstar_transpose`
  identity and instead establishes **IsIso of the canonical `pushforwardBaseChangeMap` directly at the
  affine-local level** via the already-proven `pullback_spec_tilde_iso` (Stacks 01I9) + `regroupEquiv`
  (DONE), feeding the affine-open locality criterion (`base_change_map_affine_local`, blueprint present).
  This is structurally different from the conjugate calculus: it proves the IsIso the downstream
  equalizer globalization consumes, rather than the parent-frozen map's exact section value. iter-042
  authors the blueprint section; scaffold + prover follow. Element-`ext` (iter-035 dead end) stays DROPPED.

Globalize **Čech-cohomology-free**: `H⁰(X,F)` is the equalizer `∏Γ(Uᵢ,F) ⇉ ∏Γ(Uᵢⱼ,F)`, and flat `−⊗B`
preserves that finite equalizer (`tensorEqLocusEquiv`). (Excluded direct-on-sections / term-mode
encodings: see iter sidecars.)

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
- *QUOT-defs predicate sub-builds*: P1 schematic-support + `IsProper`-support DONE; P2 rank-`r`
  local-freeness for `SheafOfModules` NEXT. `Grassmannian := QuotFunctor (𝟙 S) V Φ_d`. Forward annihilator
  char. is bridge-gated on gap1 (local/stalk shortcuts do NOT avoid it). gap1 route C→P1[DONE]→D→assembly
  is in the phase table + Mathlib gaps below.
- *QUOT-repr decomposed*: GR-cells/glue/separated (DONE); GR-proper (valuative criterion, ACTIVE); GR-quot
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
- **Q2 — FBC `gstar_transpose` discharge — RESOLVED (iter-042): conjugate route exhausted, PIVOT to
  affine tilde-transport.** The conjugate-component calculus is exhausted in-loop (5 iters, 037–041:
  one-shot reframing then layer-by-layer Fallback B both failed to assemble the multi-layer composite
  `adjL`/`adjR`). Per the armed protocol there are NO further conjugate/analogist rounds. New route: prove
  IsIso of `pushforwardBaseChangeMap` at the affine-local level via `pullback_spec_tilde_iso` + the
  locality criterion, bypassing the section-level coherence (Routes §FBC). Reversal signal: if the
  tilde-transport blueprint surfaces a structural obstruction (the canonical map's IsIso genuinely cannot
  be read off the tilde-iso without the section identity), escalate to the user — the conjugate route is
  already closed off. Obligation 1 (A2 affine reduction) is a separate owed build, unaffected.
- **Q3 — `def:hilbert_polynomial` standard-graded hypothesis (fence before any SNAP/S1 prover).** The
  Stacks-00K1 rationality engine requires `S₊` generated in degree 1, so the Hilbert-polynomial definition
  must carry a standard-graded / very-ample hypothesis (ample-only is insufficient). Verify the current
  Lean signature of `def:hilbert_polynomial` and the SNAP route statements carry it before spending prover
  budget on S1.
- **Merge-back signature check.** Confirm the re-signed `genericFlatness`/QUOT decls
  (`[IsQuasicoherent]`+`[IsFiniteType]`) match the parent cone's expected signatures.
- **Shared qcoh-affine-local infra (GF-G1 ∩ QUOT).** Both bottom at the same `isLocalizedModule_basicOpen`
  ≡ gap1 node, now decomposed into (C) `overRestrictIso` + (D) section-localization descent (the latter is
  the shared reusable keystone). Decision: build it ONCE QUOT-side (its `Scheme.Modules.*`
  namespace + blueprint home + a live consumer), NOT a copy in FlatteningStratification. Once gap1 lands,
  a mathlib-analogist API-alignment pass gates shared-extraction vs adding the import.

## Mathlib gaps & new material

Gaps to fill (detail in Routes):
- FBC-A: the `_legs`/`gstar_transpose` mate coherence (conjugate-side discharge; or bypass via the
  affine-local explicit-inverse route). No new Mathlib lemma needed.
- FBC-B: H⁰-as-equalizer / finite-affine-cover sheaf-condition packaging for `SheafOfModules` (DONE).
- GF-geo: **G1** (qcoh+finite-type ⟹ `Γ(F,W)` finite on affine `W`, via gap1) and **G3** (flat-locality
  assembly: per-patch freeness on a finite cover ⟹ flatness over `Γ(S,U)`).
- **gap1 — QCoh≃Mod affine descent (keystone bottom):** `IsQuasicoherent M → IsIso M.fromTildeΓ` on
  `Spec R`. Mathlib has `isIso_fromTildeΓ_iff` + the global-`Presentation` case only. The in-file iff
  engine + finite-cover front DONE. Two genuinely-missing lemmas remain
  (`analogies/quot-gap1-transport.md`): **(C) `overRestrictIso`** — the `M.over U ↔ M.restrict U.ι /
  Spec R_r` bridge (the ONE lemma touching the slice site; `backward.isDefEq.respectTransparency false`
  tames the synthInstance timeout); **(D) section-localization descent** (Stacks `lemma-invert-f-sections`
  / Hartshorne II.5.3) — the real keystone (sheaf equalizer + `IsLocalization.flat` over the finite
  cover). P1 (per-affine local-tilde) DONE iter-034. NOTE:
  obstacle "no restriction functor" was FALSE — `Scheme.Modules.restrictFunctor`/`pullback` exist.
- **SheafOfModules tensor powers (blocks `def:sectionGradedRing` ⟹ SNAP):** `L_s^{⊗m}` + lax-monoidal `Γ`
  absent; Mathlib-gradient sub-build owed before SNAP.
- QUOT predicates: rank-`r` local-freeness for `SheafOfModules`. QUOT-repr: Grassmannian-of-quotients as
  a scheme (Nitsure §1/§5 big-cell patching).

New project material:
- `genericFlatnessAlgebraic` (done), re-signed `genericFlatness` (+`IsQuasicoherent`+`IsFiniteType`).
- Coherence encoding = `[IsQuasicoherent]` + `[IsFiniteType]` over the locally noetherian base.
- QUOT defs with tightened signatures; `Grassmannian` via `QuotFunctor`; representability as `IsRepresentable`.

## What I need
Is the iter-042 strategy sound? Specifically: (1) the FBC PIVOT — abandoning the conjugate `gstar_transpose` route (exhausted 5 iters) for an affine tilde-transport that proves IsIso of the canonical `pushforwardBaseChangeMap` directly via `pullback_spec_tilde_iso` + locality, bypassing the section-level mate coherence. Is this structurally well-founded, or does the parent-frozen canonical map genuinely force the section identity (making the bypass illusory)? (2) Is treating QUOT gap1 as CLOSED and pivoting to consumers (G1-core/gap2/annihilator + P2) the right next QUOT focus? (3) Any phase whose Iters-left estimate is now clearly wrong?
