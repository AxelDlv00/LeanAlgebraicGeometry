# Index
<!-- One line per file. Update line numbers when the file changes. -->

- `AlgebraicJacobian/Genus.lean` — 1 sorry: `AlgebraicGeometry.genus` (L96). Iter-001 discovery confirmed Phase A blocker (no coherent sheaf cohomology of schemes in Mathlib `b80f227`). Blueprint: `chapters/Genus.tex`. Status: BLOCKED on Phase A; one step closer after iter-003 closed `instHasSheafCompose_…`. Next iteration's `Cohomology/StructureSheafAb.lean` scaffold (Phase A step 2-4) takes the next bite; honest closure of `genus` itself still requires the `Module k` structure on `H¹` plus Serre finiteness (not in scope of the upcoming refactor).
- `AlgebraicJacobian/Jacobian.lean` — 5 sorries: `Jacobian` (L77), `instGrpObj` (L88), `smoothOfRelativeDimension_genus` (L97), `instIsProper` (L104), `instGeometricallyIrreducible` (L114). Iter-001 confirmed Phase C blocker (no Picard scheme / `Pic⁰` / connected-component-of-identity API). The five sorries collapse to one representability theorem (`thm:Pic_representable` of Chapter `Picard_Functor.tex`, currently `sorry`). Blueprint: `chapters/Jacobian.tex`. Status: BLOCKED on Phase C, gated on `PicardFunctor.representable`.
- `AlgebraicJacobian/AbelJacobi.lean` — 3 sorries: `ofCurve` (L35), `comp_ofCurve` (L41), `exists_unique_ofCurve_comp` (L53). Iter-001 confirmed dependency on `Jacobian C` plus, for uniqueness, a missing rigidity theorem (Mumford §4). Rigidity helper now closed (iter-002, see `task_done.md`). Blueprint: `chapters/AbelJacobi.tex`. Status: BLOCKED on Phase C; *uniqueness* half of `exists_unique_ofCurve_comp` is technically reachable from the iter-002 `eq_of_eqOnOpen` once `Jacobian C` lands.
- `AlgebraicJacobian/Rigidity.lean` — **closed iter-002** (see `task_done.md`). Status: DONE. Phase E helper available.
- `AlgebraicJacobian/Picard/LineBundle.lean` — **closed iter-002** (see `task_done.md`). Status: DONE under documented first-approximation. Replacing `LineBundle X := CommRing.Pic Γ(X, ⊤)` with the bespoke invertible-quasi-coherent definition is gated on `MonoidalCategory X.Modules` (multi-iteration; not in scope until upstream Mathlib).
- `AlgebraicJacobian/Cohomology/SheafCompose.lean` — **closed iter-003** (see `task_done.md`). Status: DONE. Phase A step 1 instance available.
- `AlgebraicJacobian/Picard/Functor.lean` — **definition closed iter-003** (see `task_done.md`); 1 deferred sorry remaining: `PicardFunctor.representable` (L190). Blueprint: `chapters/Picard_Functor.tex` (`thm:Pic_representable`). Status: DEFERRED — closing this on the `LineBundle` first-approximation would silently assert representability of the wrong functor (forbidden shortcut). Honest closure requires (a) `LineBundle` refinement (gated on `MonoidalCategory X.Modules`) plus (b) the FGA representability argument (Hilbert / Quot schemes, multi-iteration). Do not retry until both are in motion.
- `AlgebraicJacobian/Cohomology/StructureSheafAb.lean` — **scaffolded iter-004; prover round in flight** (Phase A step 2-4 wiring). 3 sorries (L34 `instHasSheafify_Opens_AddCommGrp`, L42 `instHasExt_Sheaf_Opens_AddCommGrp`, L54 `Scheme.toAbSheaf`). Blueprint: `chapters/Cohomology_StructureSheafAb.tex`. Plan-agent live probe (recorded in `REFACTOR_DIRECTIVE.md`) showed all three closeable from existing Mathlib API plus the iter-003 `HasSheafCompose` instance; expected closures recorded in `PROGRESS.md` Objective 1 (`inferInstance` with universe pinning; `HasExt.standard _`; `(sheafCompose _ _).obj C.sheaf`). Status: PROVER PENDING.
- `AlgebraicJacobian/Picard/FunctorAb.lean` — **scaffolded iter-004; prover round in flight** (Phase C step 3 codomain change). 1 sorry (L41 `PicardFunctorAb`). Blueprint: `chapters/Picard_FunctorAb.tex`. Wraps the iter-003 `PicardFunctor.quotMap` in `AddCommGrpCat.ofHom`; no new mathematical content. Expected closure recorded in `PROGRESS.md` Objective 2. Status: PROVER PENDING.

---

## Mathlib gap (recorded once, applies to all three protected files)

Survey performed iter 001 against Mathlib commit `b80f227` (April 20, 2026); reconfirmed unchanged through iter 003:

- **Coherent sheaf cohomology of schemes**: PARTIALLY ADDRESSED. Phase A step 1 closed (iter-003 `HasSheafCompose`); steps 2-4 (`HasSheafify`, `HasExt`, `Scheme.toAbSheaf`) wiring assigned to next refactor's Track 1. After step 2-4 wiring lands, the abelian-group level definition of `H^n(C, O_C)` will be available; the remaining steps are the `Module k` structure on `H¹` (step 5) and Serre finiteness (step 6).
- **Sheaf of relative differentials of schemes** (`Ω_{X/S}`): ABSENT. Only `KaehlerDifferential` for rings. Blocks alternative definition of `genus` via $H^0(\Omega^1)$.
- **Picard scheme / Picard functor / Pic⁰**: PARTIALLY ADDRESSED. Iter-002 closed a *Picard group* approximation via global sections (`CommRing.Pic Γ(X, ⊤)`); iter-003 closed the *relative Picard functor* on top of it (Type-valued). Next refactor's Track 2 promotes to `AddCommGrpCat`-valued. Honest representability remains gated by FGA / Hilbert / Quot machinery (out of scope for ≥ 3 iterations).
- **Étale Grothendieck topology**: PRESENT on `Scheme` (`AlgebraicGeometry.Scheme.etaleTopology` in Mathlib `b80f227`); `GrothendieckTopology.over` lifts it to `Over (Spec k)`. **`HasWeakSheafify` for `Scheme.etaleTopology AddCommGrpCat` is, however, NOT inferable** (verified by `lean_run_code`); this is the real Mathlib gap blocking Phase C step 3 (étale sheafification of the Picard presheaf). Closing it is a multi-iteration project (small-site reformulation, or a Zariski-sheaf approximation as a stand-in).
- **Riemann–Roch, Serre duality**: ABSENT. Blocks dimension-of-$\Pic^0$ proofs.
- **Rigidity for morphisms of abelian varieties (Mumford §4)**: **resolved iter-002** (`AlgebraicGeometry.GrpObj.eq_of_eqOnOpen`). Independent of the protected sorries; it unlocks the *uniqueness* half of `exists_unique_ofCurve_comp` once `Jacobian C` lands.
- **Albanese variety / universal-abelian property**: ABSENT.
- **`MonoidalCategory X.Modules`**: ABSENT in `b80f227` (verified iter-002). Gates the `LineBundle` refinement; building it is multi-iteration; not in scope until upstream Mathlib gains the tensor product on sheaves of modules.
- **Available foundations**: `SmoothOfRelativeDimension`, `IsProper`, `GeometricallyIrreducible`, `Smooth`, `GrpObj` (with `instTensorUnit : GrpObj (𝟙_ C)`), `MonObj`, `η[·]`, cartesian-monoidal structure on `Over (Spec (.of k))`, `Mathlib/AlgebraicGeometry/Group/Abelian.lean`, `AlgebraicGeometry.Scheme.Modules`, `AlgebraicGeometry.smooth_of_grpObj_of_isAlgClosed`. Plus this project's iter-002 / iter-003 additions: `AlgebraicGeometry.Scheme.LineBundle`, `Pic`, `Pic.pullback`, `instHasSheafCompose_forget_CommRing_AddCommGrp`, `PicardFunctor` (def) and the `fiberMap` / `quotMap` helpers.

---

## Forbidden shortcuts (documented once)

- `genus C := 0` or any constant — false in genus $\ge 1$.
- `Jacobian C := 𝟙_ (Over (Spec (.of k)))` (terminal scheme) — forces `genus = 0` to discharge `smoothOfRelativeDimension_genus`, which is mathematically wrong.
- `Jacobian C := 𝔸¹_k`, `Spec L` (any constant scheme) — same obstruction.
- `ofCurve P := toUnit C ≫ η[Jacobian C]` (constant map to identity) — falsifies `exists_unique_ofCurve_comp` whenever a non-constant pointed morphism $C \to A$ exists (i.e. for any $g(C) \ge 1$).
- `LineBundle X := Unit` / `PUnit` / any vacuous placeholder — destroys the downstream Picard chain.
- New `axiom` declarations — forbidden by plan-agent rules.
- `PicardFunctor C := Discrete PUnit` or any vacuous functor — destroys representability and the downstream Jacobian chain.
- Closing `PicardFunctor.representable` on top of the global-sections-approximate `LineBundle` — silently asserts representability of the wrong functor. Keep the sorry in place.
- Symmetric topological-equality form of rigidity (`∀ x ∈ U, g₁.left.base x = g₂.left.base x ⇒ g₁ = g₂`) — mathematically false in characteristic `p` (Frobenius). Use the scheme-level form (`U.ι ≫ g₁.left = U.ι ≫ g₂.left ⇒ g₁ = g₂`) as in the iter-002 closure.
- For the upcoming refactor's new sorries: closing the Phase A step 2-4 wiring with `Discrete PUnit`, the unit sheaf, or any other vacuous-presheaf shortcut is forbidden — the construction must produce the actual sheafification / Ext / structure-sheaf-as-Ab-sheaf.

---

## Helper targets seeded by iter 001 / 002 / 003 / next-refactor

### Track A — Helper H1: rigidity for morphisms of abelian varieties (Phase E)

**Status: CLOSED iter-002** (see `task_done.md`).

### Track C step 1 — Phase B/C: line bundles on schemes (`LineBundle`, `Pic`, `Pic.pullback`)

**Status: CLOSED iter-002** under documented first-approximation (see `task_done.md`).

### Track B step 1 — Phase A: `HasSheafCompose` on the forget composite

**Status: CLOSED iter-003** (see `task_done.md`).

### Track C step 2 — Phase C: relative Picard functor (Type-valued)

**Status: DEFINITION CLOSED iter-003** (see `task_done.md`); representability sorry deferred indefinitely.

### Track B step 2-4 — Phase A: `HasSheafify` / `HasExt` / `Scheme.toAbSheaf` wiring

**Status: SCAFFOLDED iter-004; prover round in flight** (single new file `AlgebraicJacobian/Cohomology/StructureSheafAb.lean`, 3 sorries).

After the prover round lands, the abstract abelian-group level of `H^n(C, O_C)` is available via `(Scheme.toAbSheaf C).H n`. The remaining Phase A steps (5: `Module k` structure; 6: Serre finiteness) require new mathematical content and are deferred to subsequent iterations.

The directive's plan-agent probe (`lean_run_code`) confirmed all three closures are inferable from existing Mathlib API. Expected closures recorded in `PROGRESS.md` Objective 1.

### Track C step 3 — Phase C: relative Picard functor (`AddCommGrpCat`-valued, codomain change)

**Status: SCAFFOLDED iter-004; prover round in flight** (single new file `AlgebraicJacobian/Picard/FunctorAb.lean`, 1 sorry).

The construction wraps `PicardFunctor.quotMap` in `AddCommGrpCat.ofHom`. Functoriality follows from `quotMap_id` / `quotMap_comp` (already proven). No new mathematical content. Expected closure recorded in `PROGRESS.md` Objective 2.

The actual étale-sheafification step (Phase C step 3 proper) requires `HasWeakSheafify Scheme.etaleTopology AddCommGrpCat`, which is the genuine Mathlib gap (verified by `lean_run_code`). Building this is multi-iteration and is **not** in scope.

### Helper chains for downstream iterations (Phase A / B / C / E)

Full per-sorry chains documented in the historical task_results (now archived under `proof-journal/sessions/`). Summary:

- `genus`: chain of 6 helpers (1. HasSheafCompose **DONE**, 2. HasSheafify **PENDING**, 3. HasExt **PENDING**, 4. Scheme.toAbSheaf **PENDING**, 5. Module k structure on H¹, 6. Serre finiteness). Phase A. Steps 2-4 assigned to next refactor; steps 5-6 await later iterations.
- `Jacobian` + 4 instances: chain of 9 steps (LineBundle → Pic functor → étale sheafify → representability → connected component of identity → Jacobian → properness → smoothness/dimension → geometric irreducibility). Phase C. **Steps 1-2 DONE; step 3 codomain change PENDING (next refactor); step 3 proper (étale sheafification) blocked on the Mathlib gap; steps 4-9 await iter-005+.**
- `ofCurve`, `comp_ofCurve`: depend on `Jacobian`. Phase C. Await iter-005+.
- `exists_unique_ofCurve_comp`: depends on `ofCurve` + Helper H1 (rigidity, **DONE iter-002**) + Helper H4 (image generation, Phase E) + dual abelian variety (Phase E). Awaits iter-005+ once `Jacobian C` lands.

---

## Refactor history

- **iter-002** (executed, complete): scaffolded `AlgebraicJacobian/Rigidity.lean` (H1) and `AlgebraicJacobian/Picard/LineBundle.lean` (Track C step 1). Both helper sorries closed by the iter-002 prover round. Sorry count `13 → 9` (the 9 protected).
- **iter-003** (executed, complete): scaffolded `AlgebraicJacobian/Cohomology/SheafCompose.lean` (Phase A step 1) and `AlgebraicJacobian/Picard/Functor.lean` (Phase C step 2 — relative Picard functor + bundled representability sorry). Both *definition* sorries closed by the iter-003 prover round. Sorry count `9 → 12` post-refactor (3 new scaffold sites), then `12 → 10` post-prover (representability deferred). Two minor name adjustments documented in `task_results/refactor.md` (`Opens.grothendieckTopology` rename; `PicardFunctor` source-category change to `(Over (Spec k))ᵒᵖ`).
- **iter-004** (refactor complete; prover round in flight): plan agent verified iter-003 prover output; refactor agent scaffolded `AlgebraicJacobian/Cohomology/StructureSheafAb.lean` (Phase A step 2-4 wiring, 3 new sorries) and `AlgebraicJacobian/Picard/FunctorAb.lean` (Phase C step 3 codomain change, 1 new sorry). Pre-refactor sorry count: 10. Post-refactor sorry count: 14 (matching the directive's expected outcome). Refactor report in `task_results/refactor.md`; plan-agent verification in `PROGRESS.md`'s "Iteration 004 — post-refactor verification (PASS)" section. No protected declaration touched; no new axioms; blueprint `\lean{...}` macros resolve correctly. Prover objectives for the round in `PROGRESS.md`'s "Current Objectives — iter-004 prover round" section.
