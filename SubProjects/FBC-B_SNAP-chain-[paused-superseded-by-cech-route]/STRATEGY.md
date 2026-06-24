# Strategy

## Goal

Close the `sorry`-bearing nodes of two **Čech-independent (i=0)** legs split from the parent
*Quot-Foundations* `thm:fga_pic_representability` cone, then merge back (names/labels are the parent's):

- **FBC-B** — flat base change of the degree-0 pushforward: the i=0 map `g^* f_* F ⟶ f'_* g'^* F` is an
  isomorphism. Seeds `affineBaseChange_pushforward_iso` + `flatBaseChange_pushforward_isIso`
  (`thm:flat_base_change_pushforward`), via the CONCRETE-tilde equalizer chain.
- **SNAP** — the section graded ring `Γ_*(X,L) = ⊕_{n≥0} Γ(X,L^{⊗n})` as a graded commutative semiring
  (`lem:sectionGradedRing_gcommSemiring`) + its graded module (`lem:sectionGradedModule_gmodule`).

End-state: zero project `sorry` in these two cones, zero axioms (kernel-only).

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| FBC-B crux — ring-square naturality, RE-SCOPED to an algebra-level cocycle | RE-SCOPE | 3–5 | ~200–350 | `ModuleCat.extendScalarsComp`/`extendScalars_assoc'`, `moduleCatExtendScalarsPseudofunctor`, `Algebra.IsPushout.cancelBaseChange`, `IsBaseChange` (all present); single-map `pullbackSpecTildeNatIso` (project) | All element/mate/vcomp discharge routes walled (element route structurally DEAD — Mathlib gap, no tilde↔extendScalars bridge). Re-scope: assemble the cocycle at the `extendScalars` level (light carriers, cocycle free) + apply `tilde` once; risk = wiring the single-map dictionary per-factor without re-incurring `Γ(pullbackComp)`. |
| FBC-B downstream — global H⁰ iso assembly + 01XJ QC-pushforward | NEXT (crux-independent lanes parallel) | 2–4 | ~150–300 | `TensorProduct.piRight`; `isLocalization_basicOpen_of_qcqs` (present); `cancelBaseChange` | Module core DONE 0-sorry. Assembly climbs separated → Mayer–Vietoris → bridge. 01XJ packaging = assembly-only over the present localization lemma. |
| SNAP — `Γ_*(X,L)` graded comm ring (lax-monoidal keystone + LOCALIZED-ASSOCIATOR transport refactor) | REFACTOR | 2–4 | ~120–250 | `Adjunction.rightAdjointLaxMonoidal` + `Functor.LaxMonoidal` laws; `modulesLocalizedMonoidal` `MonoidalCategory` (in-file); `tensorObjLocalizedIso` transport; `DirectSum.GCommSemiring`/`Gmodule` | Keystone+gate landed axiom-clean; 4 `sectionsMul` cores closed. Faithful-functor reindex discharge REFUTED. PIVOT: REDEFINE `tensorObjAssoc`/unitors/`tensorBraiding` AS the localized structural isos transported via `tensorObjLocalizedIso` ⇒ coherences FREE from `MonoidalCategory` laws (+ a routine reindex-naturality piece); the 4 `sectionMul_*_core` re-route via GATE + lax laws. Decompose: refactor skeleton + separate prover fill. |

Both legs are ~10× over their original estimates (estimates revised above to reflect reality). FBC: every
mate/element/vcomp discharge route for the original mate-based crux is walled (the element route is
structurally dead — Mathlib has no tilde↔extendScalars bridge), so the crux is RE-SCOPED to an algebra-level
cocycle (decision committed; cocycle landed sorry-free, realization scaffolded — open risk = the
functor-level fill within budget). SNAP: τ-flattening was refuted (category error) and the faithful-functor
reindex discharge was refuted (sheafification-boundary mismatch); the lax-monoidal keystone+gate
landed axiom-clean and the live route is the localized-associator REFACTOR (redefine the structural isos
via `tensorObjLocalizedIso` ⇒ pentagon free). Per-iter detail in iter sidecars.

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|---|
| FBC RegroupHelper | 011 · 4 | ~120 | RegroupHelper.lean | `regroupEquiv` `(A⊗_R R')⊗_A M ≅ R'⊗_R M` axiom-clean | `eT` identity-bridge + `TensorProduct.induction_on` to beat transparent-instance diamonds | `map_smul'` zero-branch needs `erw [TensorProduct.zero_tmul]` |
| SNAP coequalizer rows | 060 · 3 | ~400 | SectionGradedRing.lean | `relTensorActL/R/Proj` objectwise coequalizer; `RelativeTensorCoequalizer` 22-decl API | carrier gap fixed by `objRestrict`; `relTensorProj.naturality` = bare-ℤ `TensorProduct.ext'` then transport to `AddCommGrpCat` | `forget₂ CommRing→Ring` carrier "blocker" illusory — real obstacle was additivity |
| SNAP crux chain + graded bricks + left-unit | 002 · ~2 | ~720 | SectionGradedRing.lean | `ztensor_whisker_localIso`, `isIso_sheafification_whiskerRight_unit`, `tensorObjAssoc`, `tensorPowAdd`; graded bricks; `sectionsMul_one_mul` | sheafification-functoriality of presheaf monoidal isos; `sectionsCast`; `adj.homEquiv` transpose core; `show`/`change` to split `Γ(f≫g)` across the `X.Modules` diamond | stalkwise / full `MonoidalCategory(SheafOfModules)` routes DEAD; carrier `AddCommGrpCat` |
| FBC module core + concrete pivot | 002 · 2 | ~500 | FlatBaseChangeGlobal.lean | `gammaTopEquivEqLocus`, `baseChangeGammaEquiv`, finite-cover equalizer; pivot off mate → concrete-tilde | `H⁰(X,F)=Γ(X,F)` = finite equalizer; flat `−⊗B` preserves it (`tensorEqLocusEquiv`) | sheaf-level adjoint-mate keystone abandoned (compile-dead) |
| FBC foundation + both mate legs + glue scaffold | 016–024 · ~8 | ~400 | FlatBaseChange.lean | `gammaPushforwardNatIso_comp`; both b2 mate legs; 5/6 `ring_square_glue_*`; geom leg made syntactic | `← conjugateEquiv_comp` split ×2 + `simp[…eq_mpr_eq_cast,cast_eq]` cast-dissolve; redefine obj-def as `…Nat.app(tilde M)` to make a defeq leg syntactic | sheaf-level `.app/.obj (tilde M)` folds = sheafification-whnf kernel bomb (any tactic); morphism-level routes only |

## Routes

Single route per leg; the two legs are independent and merge back upstream.

**FBC route — concrete-tilde equalizer chain (Čech-free).** Both seeds are reached WITHOUT the
adjoint-mate keystone. `H⁰(X,F)=Γ(X,F)` is the finite equalizer `∏Γ(Uᵢ,F) ⇉ ∏Γ(Uᵢⱼ,F)` over a finite
affine cover of a separated qc scheme, and flat `−⊗B` preserves it. Module core DONE 0-sorry
(`FlatBaseChangeGlobal.lean`). The frontier `baseChange_sheafConditionFork_tensorIso` decomposes into
per-chart iso (01I9 + Mathlib `cancelBaseChange`), the crux ring-square naturality
(`pullback_spec_tilde_iso_ring_square_natural`), and `TensorProduct.piRight` (Mathlib). Assembly climbs
separated → Mayer–Vietoris → bridge `flatBaseChange_isIso_iff_gammaTensorComparison` → goal. **Crux
status:** all mate/element/vcomp routes for the original mate-based crux are DEAD (the element route is
STRUCTURALLY dead — Mathlib has no tilde↔extendScalars bridge). **CRUX RE-SCOPED:** assemble the
base-change cocycle at the `extendScalars`/`ModuleCat` level (light carriers) and apply `tilde` ONCE. The
algebraic cocycle `chartBaseChange_extendScalars_cocycle` is DONE sorry-free (`extendScalarsComp` ×2 + one
`eqToIso` on the ring-square). The crux realization
`pullback_spec_tilde_iso_ring_square_natural_extendScalarsCocycle` (statement = crux conclusion verbatim)
is scaffolded (typed sorry). **The re-scope solved the COCYCLE, not the geometric↔algebraic BRIDGE — the
bridge is the same wall renamed.** The realization must relate the geometric comparison
`chartBaseChangeGeometricComparison` (= `(…Nat).app (tilde M)`, built from `pullbackComp` pseudofunctor
coherences) to the four single-map `pullbackSpecTildeNatIso` dictionaries WITHOUT re-incurring
`Γ(pullbackComp)` whnf. Object-level evaluation forces it (= dead `_concrete`); the functor-level glue
`ring_square_glue_natTrans` keeps `pullbackComp` abstract but its STATEMENT was over the 200k elaboration
budget. **PRIMARY route (committed — NOT a monolithic prove pass): a controlled-unfold decomposition** —
an opaque/irreducible wrapper around `chartBaseChangeGeometricComparison` so `pullbackComp` carriers do not
unfold during glue elaboration, with the unfold lemma proven separately in its own budget, plus smaller
per-leg whiskered sub-statements; one `.app M` at the very end. The sheaf-level adjoint-MATE apparatus
(`base_change_mate_*`, `pushforward_base_change_mate_*`) + the orphaned fold scaffolding are COMPILE-DEAD,
deletable in a dedicated cleanup iter (KEEP `base_change_mate_regroupEquiv`, `base_change_map_affine_local`).

**SNAP route — sheaf tensor powers ⟹ graded ring, via a LAX-MONOIDAL global-sections functor.**
`Γ_*(X,L)` is the direct sum of section groups of `L^{⊗n}`; graded multiplication is
`Γ(tensorPowAdd_{m,m'}.hom) ∘ sectionsMul` (`sectionsMul` = the section pairing, `tensorPowAdd` = the
index-addition iso `L^⊗m ⊗ L^⊗m' ≅ L^⊗(m+m')`); the graded structure rides `DirectSum.GCommSemiring`.
**Coherence comes from the lax-monoidal structure of `Γ`, NOT a hand object pentagon.** `Γ(X,-) = ι ⋙ ev_⊤`
where `ι = toPresheafOfModules` is the RIGHT ADJOINT of module sheafification, so by
`Adjunction.rightAdjointLaxMonoidal` it is lax monoidal — the KEYSTONE `toPresheafLocalized_laxMonoidal`
(landed axiom-clean). The GATE `sectionsMul_eq_laxTensorator` (landed) identifies the tensorator:
`μ_Γ|_⊤ = sectionsMul ≫ Γ(tensorObjLocalizedIso)` (NOT defeq on the nose — up to the hand↔localized object
iso). The four `sectionsMul` coherences are CLOSED at the section level via the concrete
`sectionMul_{unitor,rightUnitor,braiding,assoc}_core` lemmas (`\leanok`, independent of the object pentagon).
**The remaining graded-ring obstacle is the reindexing-iso coherences** `tensorPowAdd_{assoc,rightUnit,
braiding}` (5 sorries) — the pentagon/triangle/hexagon for the `tensorPowAdd` index isos, currently routed
through the hand `tensorObjAssoc` (the dual-instance whnf wall). The faithful-functor discharge is REFUTED:
reducing via `Faithful` of `toPresheafOfModules` lands ι(`tensorObjAssoc`), a composite of SHEAFIFIED maps;
since ι(sheaf-tensor)≠presheaf-tensor (the objects do not match: ι((A⊗B)⊗C)≠(ιA⊗ₚιB)⊗ₚιC) it is NOT the
presheaf associator and the presheaf pentagon does not apply — the reduction relocates the wall to the
sheafification boundary, it does not escape it. **LIVE discharge — the LOCALIZED-ASSOCIATOR TRANSPORT
REFACTOR** (`modulesLocalizedMonoidal` is a genuine `MonoidalCategory`, built in-file): REDEFINE
`tensorObjAssoc`/unitors/`tensorBraiding` to BE the `modulesLocalizedMonoidal` structural isos transported
(conjugated) across the hand↔localized object iso `tensorObjLocalizedIso` — KEEPING the hand tensor OBJECTS
unchanged (only the morphisms are redefined; conjugation by an explicit iso is type-correct by construction,
so the refuted `⊗_loc` re-base's object-non-defeq failure cannot recur). This makes the hand↔localized
associator agreement DEFINITIONAL (it was the demoted `tensorObjAssoc_eq_localizedAssociator` bridge whose
`hK_lhs_native` step is the irreducible dual-instance wall — the refactor sidesteps it by construction).
Then the associator/unitor/braiding COHERENCES come FREE from the `modulesLocalizedMonoidal`
pentagon/triangle/hexagon; **CAVEAT (do not assume away):** `tensorPowAdd_*` additionally carries the
exponent-reindexing iso `L^⊗m⊗L^⊗m'≅L^⊗(m+m')` (a `Nat`-recursion iso) whose NATURALITY against the
associator is a separate (routine) obligation, NOT literally the pentagon. The four `sectionMul_*_core`
re-route via the landed GATE `sectionsMul_eq_laxTensorator` + the keystone lax
`associativity`/unitality/braided laws (keystone+gate are LOAD-BEARING for this route). Then
`sectionGradedRing_gcommSemiring` + `sectionGradedModule_gmodule` assemble. **PROCESS:** decompose — a
refactor subagent lands the `tensorObjAssoc`/unitor/braiding redefinition skeleton (sorries at the
`sectionMul_*_core` re-route sites), then a SEPARATE prover fills (same-file ⇒ sequential, never one agent
re-base+re-prove). **Dead alternatives (do not re-attempt):** τ-flattening (`μΓ_collapse`, `Γ(η)`-pushforward
of a constructed `τ:Γ(L^m)⊗Γ(L^m')→Γ(P)`) — category error (`Γ(L^⊗m)≠Γ(L)^{⊗m}`, sheafification has no
section on `Γ`); the faithful-functor reindex reduction (above); the `⊗_loc` move-free RE-BASE (changes the
tensor objects, kernel type-mismatch — distinct from the TRANSPORT refactor, which keeps them). Live recipe
`analogies/snap-tau-construction.md`; `snap-gradedring-route.md`/`snap-instance-design.md` SUPERSEDED.

## Open strategic questions

- **FBC — can the crux REALIZATION fit the 200k per-decl elaboration budget?** This is the crux's last
  open question. The functor-level glue must keep `pullbackComp` abstract (object-level forces the
  `Γ(pullbackComp)` bomb of the dead `_concrete`), but the known monolithic glue statement was over budget
  (elaborated only at 800k). LIVE plan: a controlled-unfold decomposition — opaque/irreducible wrapper
  around `chartBaseChangeGeometricComparison` + a separately-budgeted unfold lemma + smaller per-leg
  whiskered sub-statements; one `.app M` at the end. This is an effort-breaker/refactor decomposition task,
  NOT a single prove pass. If even the decomposed sub-statements cannot be fit, the seed must be re-scoped.
- **SNAP — does the `sectionMul_*_core` re-route survive the transport refactor?** After redefining the
  structural isos via `tensorObjLocalizedIso`, the cores re-route through the GATE + lax laws; the separate
  `tensorPowAdd` exponent-reindex-naturality obligation must also be discharged. If the re-route itself
  walls → genuine residual difficulty, re-consult the analogist before more budget.
- **FBC qcqs-pushforward-QC (Stacks 01XJ) — sub-prerequisite CONFIRMED PRESENT; build = assembly only.**
  The hard analytic core `AlgebraicGeometry.isLocalization_basicOpen_of_qcqs` IS in Mathlib
  (`…Morphisms.QuasiSeparated`, verified sc024). Only the QC-preservation-under-pushforward packaging is
  project-side (`[prover-mode: mathlib-build]`, ~100–200 LOC). No longer "UNCONFIRMED".
- **FBC chain signatures.** Scaffolded chain decls (`baseChange_sheafConditionFork_tensorIso`,
  `baseChangeEqLocusToPullbackGamma`, `baseChangeGammaPullbackEquiv`) omit
  `[IsSeparated X]`/finiteness/`[F.IsQuasicoherent]`; add (re-sign freely, not protected) when sorries fill.
- **FBC parallelism (sc024 must-fix).** The downstream seeds, the 01XJ build, and the global assembly are
  mutually independent — dispatch concurrently to hit the 1–3-iter estimate; serialized expect ~2×.

## Mathlib gaps & new material

Gaps to fill:
- FBC: the crux realization `pullback_spec_tilde_iso_ring_square_natural_extendScalarsCocycle` (algebraic
  cocycle `chartBaseChange_extendScalars_cocycle` DONE) — needs the kernel-light FUNCTOR-level
  assembly relating `chartBaseChangeGeometricComparison` (`pullbackComp`-built) to the four single-map
  `pullbackSpecTildeNatIso` dictionaries within the 200k budget, then one `.app M`; on success retarget the
  crux `_ring_square_natural` body. Then `pullback_spec_tilde_iso_restriction_naturality`,
  `TensorProduct.piRight` (present), 01XJ packaging over `isLocalization_basicOpen_of_qcqs`.
- SNAP: the reindexing-iso coherences `tensorPowAdd_{assoc,rightUnit,braiding}` FREE from the
  `modulesLocalizedMonoidal` pentagon/triangle/hexagon after the localized-associator refactor; the four
  `sectionMul_*_core` re-routed via the GATE + lax laws (keystone+gate DONE).

New project material:
- FBC concrete chain (per-chart iso + ring-square naturality + finite-product commutation + assembly).
- SNAP: lax-monoidal keystone/gate (DONE) + tensor-power reindex coherences + the `Γ_*(X,L)` graded
  (co)semiring/module instances.
