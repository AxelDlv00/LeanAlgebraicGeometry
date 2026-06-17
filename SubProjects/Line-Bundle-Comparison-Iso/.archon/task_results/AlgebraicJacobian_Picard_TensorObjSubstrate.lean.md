# AlgebraicJacobian/Picard/TensorObjSubstrate.lean

Objective 2 (D3′ route): introduce the Sq bricks and close `pullbackTensorMap_restrict` (the
4-square interleave, typed sorry ~L3151/3184). Sorry count: 2 before → 2 after (no sorry closed;
one new axiom-clean helper lemma added).

## sheafifyMap_pullbackComp_hom_inv_id (NEW brick — RESOLVED, axiom-clean)
### Approach
Brick 1 of the objective (the step-(i) cancellation `D ≫ E = 𝟙`). Top-level `private lemma`
just before `pullbackTensorMap_restrict`:
`aZ.map (pbComp.hom.app T) ≫ aZ.map (pbComp.inv.app T) = 𝟙`, for the Mathlib presheaf coherence
`PresheafOfModules.pullbackComp φf φh` under sheafification `aZ`.
### Result
RESOLVED. Proof: `rw [← Functor.map_comp]; erw [Iso.hom_inv_id_app]; exact aZ.map_id _`.
`lean_verify` → axioms `{propext, Classical.choice, Quot.sound}` only (axiom-clean).
### Key insight
- `Functor.map_id`/`Functor.map_comp` resolve to the **monad** `Functor` first — must use
  `CategoryTheory.Functor.map_id` or, cleaner, `aZ.map_id _` / `aZ.map_comp`.
- `Iso.hom_inv_id_app` will NOT fire with `rw` after the `← Functor.map_comp` merge (the merged
  `≫` sits at the `Sheaf.val Z` carrier instance, not the `Z.presheaf ⋙ forget₂` instance the
  iso carries) — `erw` bridges the defeq.

## pullbackTensorMap_restrict (the D3′ 4-square interleave — IN PROGRESS, sorry retained)
Context recap: after the iter-006 prefix the goal (just before the sorry) is the explicit
4-vs-10 factor identity. The prefix already did Sq2b (`hδ` via `pullbackComp_δ`, CLOSED) and the
Sq1 unit identity (`h1` via `sheafificationCompPullback_comp`, CLOSED). The residual is steps
(i) cancellation, (ii) `comp_δ` split, (iii) the Sq3/Sq4 interleave.

### Attempt 1 — step (i) cancellation splice
- **Approach:** prove `D ≫ E = 𝟙` (brick above) then splice it into the goal LHS
  `(R0 ≫ R1 ≫ R5 ≫ D) ≫ (E ≫ Fδ ≫ Gt) ≫ S3 ≫ S4`, where `D = aZ.map (pbComp.hom.app T)`
  (from `h1`/Sq1) and `E = aZ.map (pb.inv.app T)` (from `hδ`/Sq2b).
- **Result:** FAILED to splice — blocked by a **pervasive non-canonical-instance wall**, diagnosed
  precisely (multiple verified-failed routes):
  1. `simp only [Category.assoc]` does NOT cross the group1/group2 boundary `≫` (leaves
     `(R0≫R1≫R5≫D) ≫ ...` bracketed). Verified.
  2. plain `rw [Category.assoc]` reports `(?f ≫ ?g) ≫ ?h` **not found** — the boundary `≫` is at a
     non-`Category.toCategoryStruct` instance (conv error names `@CategoryStruct.comp _
     Category.toCategoryStruct _ ...` failing to unify). Verified.
  3. `slice_lhs` cannot bracket `D`,`E`: its DFS numbering puts `D` at pos 8 (deep-right of group1),
     `E` at pos ~2 (left of group2) — different branches separated by the boundary. Verified by
     inspecting `slice_lhs {2 3,3 4,5 6,6 7}` foci.
  4. `erw [Category.assoc]` DOES cross (defeq) but **whnf-unfolds `R0 = (pullbackComp h f).inv.app`**
     into its raw `mateEquiv`/`TwoSquare.equivNatTrans`/`leftUnitor` definition (its `.inv` is itself
     a composite) — catastrophic dead end. Verified.
  5. ROOT: even `rw [h1]` / `rw [reassoc_of% h1]` at L3087 fail to match the goal's
     `(sheafCompPb (h≫f)).app(M⊗N).hom` factor — confirming the non-canonical instance is **inherent
     to the goal spelling** (introduced by `simp only [pullbackTensorMap, tensorObjIsoOfIso]` +
     `Functor.map_comp` unfolds, whose `mapIso.hom` morphisms carry non-canonical category structs),
     not merely a boundary artifact. The original author's `erw [reassoc_of% h1]` was forced for this
     reason; it propagates the non-canonical `≫` everywhere.
- **Net effect:** every assoc-based manipulation of this goal must go through `erw`/defeq, but the
  one place defeq is needed (assoc across the boundary) also whnf-unfolds `R0`. The cancellation is
  blocked *upstream of itself* by goal-wide instance normalization.

## Why I stopped — Partial progress
- **Real code progress:** added one **axiom-clean, compiling** helper lemma
  `sheafifyMap_pullbackComp_hom_inv_id` (brick 1 of the objective; the step-(i) cancellation,
  genuinely proven, not a sorry). Added `set_option maxHeartbeats 3200000 in` on
  `pullbackTensorMap_restrict` (the assembly will exceed default once tactics are added).
- **Did NOT close** the `pullbackTensorMap_restrict` sorry. The blocker is not difficulty-of-search
  but a concrete, now-precisely-characterized **instance-normalization wall**: the goal produced by
  the iter-006 prefix carries non-`Category.toCategoryStruct` morphism instances throughout, so no
  canonical-assoc tactic (`rw`/`simp`/`slice`) can manipulate it, while `erw [Category.assoc]`
  destroys `R0` by unfolding `(pullbackComp h f).inv`. Steps (ii) `comp_δ` split and (iii) the Sq3
  (`sheafifyTensorUnitIso`) / Sq4 (`pullbackValIso`) composition coherences sit behind step (i).
- This is the same frontier the planner flagged ("genuinely new obstacle beyond the unit-analog
  pattern"); the bricks `sheafifyTensorUnitIso_comp` (Sq3) and `pullbackValIso_comp` (Sq4) were NOT
  introduced because they are downstream of an interleave that cannot be assembled until the goal's
  instance spelling is normalized.

### Concrete NEXT STEP for this lane (documented in-code above the sorry)
Re-engineer the prefix so the goal stays at the **canonical** `SheafOfModules Z` composition before
the cancellation, e.g.:
- replace `simp only [pullbackTensorMap, tensorObjIsoOfIso]` + `Functor.map_comp` + `erw [reassoc_of%
  h1]` (L3083–3087) with an assembly that does NOT introduce non-canonical `mapIso.hom` structs
  (e.g. work with the `Iso`s directly via `≪≫`/`Iso.trans` and only convert to `≫` at the end), OR
- after L3087, insert a one-shot re-canonicalization (`change`/`show` to the canonical composition,
  or `convert … using 1`) so downstream `simp only [Category.assoc]` flattens.
Then step (i) closes by `simp only [Category.assoc]` + `rw [sheafifyMap_pullbackComp_hom_inv_id,
Category.id_comp]`; step (ii) by `Functor.OplaxMonoidal.comp_δ`; step (iii) is the genuine remaining
4-square interleave (Sq3 `sheafifyTensorUnitIso` vs `pullbackComp`; Sq4 `pullbackValIso` factoring
through Sq1 + counit naturality).

## Needs blueprint entry
- `AlgebraicGeometry.Scheme.Modules.sheafifyMap_pullbackComp_hom_inv_id` (new `private lemma`, just
  before `pullbackTensorMap_restrict`). Uses: `Functor.map_comp`, `Iso.hom_inv_id_app`,
  `Functor.map_id`. Role: the step-(i) cancellation brick (Sq-cancellation) of the D3′ four-square
  interleave `lem:pullback_tensor_map_basechange`. Reviewer/planner: add a `\label`+`\lean`+`\uses`
  block so the Lean ↔ blueprint 1-to-1 holds (it will otherwise surface in `leandag unmatched`).

## Summary
- Sorry count: **2 → 2** (no sorry closed).
- Sorries still open: L712 `exists_tensorObj_inverse` (deferred, import-cycle — not in scope);
  `pullbackTensorMap_restrict` D3′ interleave (blocked on goal-wide instance normalization, precisely
  diagnosed; brick 1 proven and staged).
- Adjacent sorries: only the deferred L712 (explicitly out of scope this iter) — not attempted.
- New compiling helper: `sheafifyMap_pullbackComp_hom_inv_id` (axiom-clean).
