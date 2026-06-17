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
| FBC-A — affine lemma, direct-on-sections | ACTIVE | 1–2 | ~60–150 | tilde dictionaries; `conjugateEquiv_counit_symm`, `Adjunction.comp_counit_app` | keyed-rewriting CONCLUSIVELY DEAD vs `X.Modules` diamond (iter-029). iter-031 ROOT-CAUSE: the prescribed splice route was NEVER EXECUTABLE — the 3 eCancel atoms are declared AFTER `_legs`, out of scope at the sorry (a declaration-ordering bug, NOT a math wall; cf. GR no-output bug). Corrective (route b): build the 3 wrapper links INLINING in-scope cancellers (`pullback_isEquivalence_of_iso`@762, `(pullbackComp _).hom_inv_id_app`, `gammaMap_pushforwardComp_hom_eq_id`@1174) + collapse `Eq.mpr` casts via concrete-legs read. OVER_BUDGET (entered iter-018); REVISED tripwire: if `_legs` not closed THIS round (route now actually executable) → iter-033 decides ModuleCat re-encoding vs user escalation |
| FBC-B — globalization, H⁰-equalizer | NEXT | 2–5 | ~120–300 | `Mathlib.RingTheory.Flat.Equalizer`; finite affine cover + sheaf condition for `SheafOfModules` | flat-equalizer half Mathlib-backed; residual = H⁰-as-equalizer packaging. Sequenced after gstar |
| GF-geo — `genericFlatness` | ACTIVE | 2–4 | ~120–300 | algebraic core (done); `Module.flat_of_isLocalized_maximal`; `HasRingHomProperty.appLE` | base `[IsIntegral S]`+`[QuasiCompact p]` required (else false). G1/G3 Mathlib-absent, project-built; G1 bottoms at gap1 (QUOT-side) — GF dispatch deferred until gap1 lands |
| GR-sep/proper — `isSeparated` + `isProper` | ACTIVE | 2–4 | ~120–300 | diagonal closed immersion via affine-chart cover; valuative criterion (proper) | `Grassmannian.scheme` DONE (iter-031). Separated = diagonal closed immersion checked on `U^I×U^J` cover (surjective comorphism `δ_{I,J}`, Nitsure §1); proper sequenced after separated. Self-contained, NO keystone dep |
| QUOT-defs — Quot/Grassmannian defs + predicates | ACTIVE (infra-gated) | 3–6 | ~180–460 | `Presentation.map`; `isIso_fromTildeΓ_of_presentation`; `QuasicoherentData.bind` template | gap1 4-step decomp: (C) `overRestrictIso` bridge **DONE axiom-clean iter-031** (step-2 collapsed to `rfl`; +`overRestrictPullbackIso` for P1); (P1) per-affine local-tilde **NOW UNBLOCKED** (`overRestrictPullbackIso`+`Presentation.map`+`isIso_fromTildeΓ_of_presentation`); (D) section-localization descent [keystone, Stacks 01HA]; (4) assembly via in-file iff. annihilator/SNAP gated; 4 stubs protected |
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
the projection legs (WALLED: dependent-motive obstruction). The `_legs` step-(iii) eCancel assembly is now
DECOMPOSED (effort-breaker `fbc-legs`) into 5 clean-term link sub-lemmas (`_link_distribute`,
`_link_collapseComp`, `_link_cancelEUnit`, `_link_cancelPullbackComp`, `_link_survivor`) — each stated on
freshly-elaborated terms (one instance ⇒ no diamond, ≤30 LOC), assembled by one closing `exact` that
crosses the `X.Modules` diamond by defeq. Keyed `rw`/`simp`/`erw` are CONCLUSIVELY dead (iter-029). The
SHIPPED eCancel atoms are spliced via `congrArg`/`Functor.congr_map`/`.trans`. Globalize
**Čech-cohomology-free**: `H⁰(X,F)` is the equalizer `∏Γ(Uᵢ,F) ⇉ ∏Γ(Uᵢⱼ,F)` (sheaf condition, degree
0/1), and a flat `−⊗B` preserves that finite equalizer.

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
  engine + finite-cover front DONE. **(C) `overRestrictIso` DONE axiom-clean (iter-031)** — step-2
  ring-sheaf id collapsed to `rfl`; `overRestrictPullbackIso` added for the P1 consumer. Remaining:
  **(P1) per-affine local-tilde** (`lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`) — NOW UNBLOCKED via
  `overRestrictPullbackIso`+`Presentation.map`+`isIso_fromTildeΓ_of_presentation`; **(D)
  section-localization descent** (Stacks 01HA / Hartshorne II.5.3) — the real keystone (sheaf equalizer +
  `IsLocalization.flat` over the finite cover); then (4) assembly via the in-file iff.
- **SheafOfModules tensor powers (blocks `def:sectionGradedRing` ⟹ SNAP):** `L_s^{⊗m}` + lax-monoidal `Γ`
  absent; Mathlib-gradient sub-build owed before SNAP.
- QUOT predicates: rank-`r` local-freeness for `SheafOfModules`. QUOT-repr: Grassmannian-of-quotients as
  a scheme (Nitsure §1/§5 big-cell patching).

New project material:
- `genericFlatnessAlgebraic` (done), re-signed `genericFlatness` (+`IsQuasicoherent`+`IsFiniteType`).
- Coherence encoding = `[IsQuasicoherent]` + `[IsFiniteType]` over the locally noetherian base.
- QUOT defs with tightened signatures; `Grassmannian` via `QuotFunctor`; representability as `IsRepresentable`.
