# Refactor Directive

## Slug

`alt-zsmul-pi-smul-aux-sum-comp`

## Problem

In `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`, the proof of
`cechCofaceMap_pi_smul` has been stalled for three consecutive prover lanes
(iter-099, iter-100, iter-101) on the per-summand R-linearity hypothesis
`?hG` of the application of `alternating_sum_pi_smul_aux_sum_comp` at lines
L710-L712. The structural blocker is identified and confirmed by independent
in-vacuum testing:

> Lean's discrimination tree cannot pattern-match `(?n • ?f) ≫ ?g`,
> `(n • f).hom`, `f ≫ Pi.π _`, etc. when `?f = Pi.lift fun i_1 ↦ <body
> referencing outer i>` with anonymous-closure codomain
> `∏ᶜ (fun i_1 ↦ ModuleCat.of k Γ(...))`. The lemma `ModuleCat.hom_zsmul`
> is `rfl` and applies in vacuum (verified iter-100 via `lean_run_code`),
> but on the in-context Pi.lift the discrimination tree fails to find an
> occurrence syntactically. The same class of failure blocks
> `Preadditive.zsmul_comp`, `Linear.smul_comp`, `Preadditive.nsmul_comp`,
> `ModuleCat.hom_smul`, body-local rfl-helpers, and `set f := Pi.lift _`.

The iter-101 prover landed S1-S3 of a post-funext recipe (Pi.smul_apply +
show pivot + four-layer `← ConcreteCategory.comp_apply` to fuse to a single
categorical morphism `((-1)^↑i • Pi.lift_thing) ≫ eqToHom ≫ Pi.π Z₂ j'`),
but S4 (scalar extraction via `Preadditive.zsmul_comp`) still fails for the
same root cause. Six tactic-level routes are exhausted across the three
iterations.

The current `alternating_sum_pi_smul_aux_sum_comp` (L513-L537) takes a
morphism family `G : ι' → ((∏ᶜ Z₁) ⟶ (∏ᶜ Z_int))` and an intermediate
`E : (∏ᶜ Z_int) ⟶ (∏ᶜ Z₂)`. The iter-099 call site uses Miller-pattern
unification to fill `?G i := (-1)^↑i • Pi.lift_thing_i` (sign BAKED into G).
The per-summand hypothesis `hG` is then about
`((-1)^↑i • Pi.lift_thing_i) ≫ eqToHom`, which is exactly where the
discrimination-tree class fails — the prover cannot extract `(-1)^↑i` from
inside `G i`.

## Mathematical Justification

The Čech alternating coface differential decomposes uniformly as
`∑ i, σ i • f_i ≫ e` where:
- `σ i : ℤ` is the per-summand sign `(-1)^↑i`,
- `f_i : ∏ᶜ Z₁ ⟶ ∏ᶜ Z_int` is a *sign-free* Pi.lift / projection /
  presheaf-map composite,
- `e : ∏ᶜ Z_int ⟶ ∏ᶜ Z₂` is the `eqToHom` adjusting Pi-product indexing.

R-linearity of the alternating sum follows from:

1. **Preadditive distribution**: `(∑ i, σ i • G i) ≫ E = ∑ i, σ i • (G i ≫ E)`
   via `Preadditive.zsmul_comp`. **HOU-free at the lemma binder level**
   because `G : ι' → (X ⟶ Y)` is a typed binder; no anonymous-closure under
   the smul.
2. **Per-summand**: each `σ i • (G i ≫ E)` is R-linear from `G i ≫ E`
   R-linear (given as `hG`). The proof uses:
   - `ModuleCat.hom_zsmul (n := σ i) (f := G i ≫ E)`, which fires `rfl`
     at the binder level (HOU-free).
   - `smul_comm (σ i) r y`, which holds because ℤ-action commutes with
     R-action on any abelian group (`SMulCommClass ℤ R N` or
     `Module.toAddCommGroup`+`IsScalarTower ℤ R N` available via
     `AddCommGroup` instance — both routes are standard).
3. **Apply `alternating_sum_pi_smul_aux`** with the per-summand-derived
   hypothesis as `F i := σ i • (G i ≫ E)`.

The key insight: by *taking `σ` and `G` as separate binders*, the
per-summand smul-extraction proof happens at the BINDER LEVEL (inside the
new lemma's body), where the discrimination tree has no anonymous-closure
to choke on. The CALL SITE then only needs to discharge the **sign-free**
hypothesis `hG : ∀ i, e₂ ((G i ≫ E).hom (e₁.symm (r • y))) = r • e₂ ((G i ≫ E).hom (e₁.symm y))`,
i.e. R-linearity of the sign-free Pi.lift / restriction composite. That
discharge is intrinsic to `RingHom.toModule (presheaf.map _).hom` and
handled by the project-local `presheafMap_restrict_collapse` (L425,
fully proved iter-087) per coordinate.

This pattern mirrors the iter-096 → iter-097 success: when iter-095 routes
G/H/I all failed at discrimination-tree HOU, the iter-096 refactor
extracted an abstract structural lemma whose summand family was a single
binder `F : ι' → (M ⟶ N)`. Application via `refine` used Miller-pattern
unification (HOU-free at the application site), and the body's proof was
trivial because `F` was a binder. The current refactor does the same trick
one layer deeper: peel `σ` out of `F` as a separate binder.

## Changes Requested

### Change 1: Insert new lemma `alternating_zsmul_pi_smul_aux_sum_comp`

Insert the following new theorem in `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`
**directly after** the closing line `exact alternating_sum_pi_smul_aux Z₁ Z₂ s (fun i ↦ G i ≫ E) e₁ e₂ hG r y`
of `alternating_sum_pi_smul_aux_sum_comp` (currently at L537). The new
theorem extends `_sum_comp` with per-summand sign handling.

```lean
/-- Iter-102 refactor: zsmul-through-composition extension of
`alternating_sum_pi_smul_aux_sum_comp`. Adds a per-summand sign
`σ : ι' → ℤ` as a separate binder so that the per-summand R-linearity
hypothesis `hG` is about the **sign-free** composite `G i ≫ E` rather than
the sign-wrapped `(σ i • G i) ≫ E`. The body internally handles the
sign-to-R-action commutativity at the binder level, where Lean's
discrimination tree has no anonymous-closure to choke on.

This unblocks the `cechCofaceMap_pi_smul` `?hG` discharge: the iter-099
call site bakes `(-1)^↑i` into `?G`, leading to a discharge that requires
`Preadditive.zsmul_comp` on a Pi.lift with anonymous-closure codomain —
three consecutive prover lanes (iter-099, iter-100, iter-101) failed on
this class. With the new lemma, the discharge is about the sign-free
`Pi.lift_thing_i ≫ eqToHom`, which is closed via
`presheafMap_restrict_collapse` per coordinate.

Body left as `sorry` for the iter-103 prover. Proof sketch (~5-10 lines):
1. `intro r y`.
2. `rw [Preadditive.sum_comp s (fun i ↦ σ i • G i) E]` to distribute
   composition through the sum. The pattern `?f ≫ ?g` with `?f := σ i • G i`
   is HOU-free because the *family* `fun i ↦ σ i • G i` is a binder
   structurally identical to the family `G` in the iter-099 `_sum_comp`
   body.
3. `simp_rw [Preadditive.zsmul_comp]` to pull each `σ i • _` outside the
   composition. **HOU-free** because `G` is a binder; `Preadditive.zsmul_comp`
   pattern `(?n • ?f) ≫ ?g` matches with `?f := G i` (typed variable).
4. Apply `alternating_sum_pi_smul_aux` with `F i := σ i • (G i ≫ E)` and
   a derived per-summand hypothesis `hF` proved inline from `hG` using
   `ModuleCat.hom_zsmul` + `smul_comm` + `hG`. All three steps work at
   the binder level.
-/
theorem alternating_zsmul_pi_smul_aux_sum_comp
    {k : Type u} [Field k]
    {R : Type*} [Ring R]
    {ι₁ : Type u} {ι_int : Type u} {ι₂ : Type u}
    (Z₁ : ι₁ → ModuleCat.{u} k)
    (Z_int : ι_int → ModuleCat.{u} k)
    (Z₂ : ι₂ → ModuleCat.{u} k)
    [_mZ1 : Module R ((∀ i, Z₁ i))] [_mZ2 : Module R ((∀ j, Z₂ j))]
    {ι' : Type*} (s : Finset ι')
    (σ : ι' → ℤ)
    (G : ι' → ((∏ᶜ Z₁ : ModuleCat.{u} k) ⟶ (∏ᶜ Z_int : ModuleCat.{u} k)))
    (E : (∏ᶜ Z_int : ModuleCat.{u} k) ⟶ (∏ᶜ Z₂ : ModuleCat.{u} k))
    (e₁ : (∏ᶜ Z₁ : ModuleCat.{u} k) ≃ₗ[k] ∀ i, Z₁ i)
    (e₂ : (∏ᶜ Z₂ : ModuleCat.{u} k) ≃ₗ[k] ∀ j, Z₂ j)
    (hG : ∀ i ∈ s, ∀ (r : R) (y : ∀ i, Z₁ i),
      e₂ ((G i ≫ E).hom (e₁.symm (r • y))) =
        r • e₂ ((G i ≫ E).hom (e₁.symm y))) :
    ∀ (r : R) (y : ∀ i, Z₁ i),
      e₂ (((∑ i ∈ s, σ i • G i) ≫ E).hom (e₁.symm (r • y))) =
        r • e₂ (((∑ i ∈ s, σ i • G i) ≫ E).hom (e₁.symm y)) := by
  sorry
```

**Place this theorem AFTER `alternating_sum_pi_smul_aux_sum_comp` and
BEFORE `set_option maxHeartbeats 1600000 in` (which precedes
`cechCofaceMap_pi_smul`).** Currently the gap is at L538-L539; insert
between L537 (`exact alternating_sum_pi_smul_aux ... r y`) and L539
(`set_option maxHeartbeats 1600000 in`).

### Change 2: Update call site in `cechCofaceMap_pi_smul`

The current iter-099 call site at L710-L712 is:

```lean
  rw [← Pi.smul_apply (i := j)]
  refine congrFun
    (alternating_sum_pi_smul_aux_sum_comp Z₁ _ Z₂ Finset.univ _ _ e₁ e₂ ?_ r y) j
```

**Replace** with:

```lean
  rw [← Pi.smul_apply (i := j)]
  refine congrFun
    (alternating_zsmul_pi_smul_aux_sum_comp Z₁ _ Z₂ Finset.univ
      (fun i : Fin (n + 1) ↦ ((-1 : ℤ))^(↑i : ℕ)) _ _ e₁ e₂ ?_ r y) j
```

This Miller-unifies:
- `?Z_int` from codomain of `Pi.lift` summands (same as before).
- `?σ := fun i ↦ (-1)^↑i` (explicit; ascribed to `Fin (n + 1) → ℤ` if
  Lean cannot infer the type from `?G`'s domain).
- `?G := fun i ↦ Pi.lift_thing_i` (the SIGN-FREE Pi.lift; matches against
  the goal's `((-1)^↑i • Pi.lift_thing_i) ≫ eqToHom` literal after
  factoring out `(-1)^↑i •`).
- `?E := eqToHom _`.
- `?_ := ?hG` per-summand discharge (sorry for iter-103).

### Change 3: Prune the iter-099/iter-100/iter-101 cumulative residual

The current cumulative chain from L713 to L811 inside `cechCofaceMap_pi_smul`
attempts to discharge `?hG` post-iter-099 application and has accumulated
extensive diagnostic comments + partial iter-101 S1-S3 fuse. **This entire
block becomes obsolete** under the new lemma's discharge (which is
sign-free).

**Replace lines L713 through L811 (inclusive)** with the following
streamlined skeleton:

```lean
  -- Iter-102 refactor: per-summand hypothesis is now about the
  -- SIGN-FREE composite `Pi.lift_thing_i ≫ eqToHom`. The
  -- discrimination-tree blocker that defeated iter-099/100/101 sat in the
  -- `(-1)^↑i • _` wrapper around Pi.lift; with the sign peeled into the
  -- new lemma's `σ` binder, the discharge is intrinsic to
  -- `RingHom.toModule (presheaf.map _).hom` per coordinate. The iter-103
  -- prover closes this via `funext j'` + Pi.lift_π_apply / eqToHom
  -- normalization + `presheafMap_restrict_collapse`.
  intro i _ r' y'
  sorry
```

This:
- Preserves the binder names `i, _, r', y'` to match the iter-099 `?hG`
  hypothesis shape (`∀ i ∈ s, ∀ r y, ...`).
- Leaves a SINGLE trailing `sorry` for the iter-103 prover to fill.

### Change 4: Optional — adjust `set_option maxHeartbeats` if needed

The current `set_option maxHeartbeats 1600000 in` precedes `cechCofaceMap_pi_smul`
(L539). The new lemma `alternating_zsmul_pi_smul_aux_sum_comp` has a simple
body sketch; no heartbeat boost should be needed. If the refactor agent
finds the new lemma's elaboration timing out (unlikely for the signature),
add a `set_option maxHeartbeats 400000 in` directly before the new lemma
declaration.

## Affected Files

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` — only file edited.

No other files depend on `alternating_sum_pi_smul_aux_sum_comp` directly,
so adding a sibling lemma does not cascade.

## Expected Outcome

After this refactor:
- File compiles end-to-end (`lean_diagnostic_messages` severity=error
  returns `[]`).
- Total sorries in `BasicOpenCech.lean`: **6 → 7** (+1 for the new
  lemma's body sorry; +0/-0 for the call site sorry change, since the
  iter-099/100/101 trailing sorry at L811 migrates to the new `?hG`
  discharge site at ~L713-L715).
- Line counts: `cechCofaceMap_pi_smul` body shrinks by ~95 lines (the
  L713-L811 cumulative residual is pruned to a ~10-line stub); the new
  lemma adds ~25 lines. Net: file shrinks by ~70 lines.
- Iter-103 prover then fills two sorries simultaneously:
  1. The new lemma's body (~5-10 lines): `Preadditive.sum_comp` +
     `simp_rw [Preadditive.zsmul_comp]` + `alternating_sum_pi_smul_aux` with
     binder-level hypothesis derivation.
  2. The new `?hG` discharge inside `cechCofaceMap_pi_smul` (~20-30 lines):
     `funext j'` + Pi.lift_π / eqToHom normalization +
     `presheafMap_restrict_collapse` per coordinate. The sign-free
     composite has no anonymous-closure issue post-funext, so the iter-101
     S4-S6 recipe applies cleanly.
- Target net for iter-103: BasicOpenCech 7 → 5 sorries.

## Constraints

- **No new axioms.**
- **No protected declarations modified.** None of the new declarations
  appear in `archon-protected.yaml`.
- **Preserve byte-for-byte**:
  - `presheafMap_restrict_collapse` (L425, iter-087).
  - `alternating_sum_pi_smul_aux` (L462-L494, iter-097).
  - `alternating_sum_pi_smul_aux_sum_comp` (L513-L537, iter-098/099).
  - `cechCofaceMap_pi_smul` SIGNATURE (L559-L597).
  - `cechCofaceMap_pi_smul` BODY PRELUDE through L709 — `intro R K₀ scK₀
    Z₁ Z₂ e₁ e₂ r y`, body-local `letI` reconstruction (L599-L622),
    `funext j; simp only [Pi.smul_apply]; have hRel; dsimp only; simp [...];
    rw [show ...]; show ...; rw [piIsoPi_hom_ker_subtype_apply];
    have hom_sum_dist; have key₁; rw [← ModuleCat.hom_comp]` chain
    L623-L709. Iter-099 B1 bridge at L699.
  - Iter-099 application chain at L710-L712 is REPLACED by Change 2;
    the surrounding context is preserved.
- **Do NOT delete `alternating_sum_pi_smul_aux_sum_comp`** — the new
  lemma's body will call it as a building block (via internal reduction
  to `alternating_sum_pi_smul_aux`, but `_sum_comp` may also be useful
  directly in future code).
- **Do NOT modify `archon-protected.yaml`.**

## Verification

After refactor, run:
```bash
${LEAN4_PYTHON_BIN:-python3} "$LEAN4_SCRIPTS/sorry_analyzer.py" \
  AlgebraicJacobian/Cohomology/BasicOpenCech.lean --format=summary
```
Expected: 7 sorries.

And via Lean LSP:
```
lean_diagnostic_messages(AlgebraicJacobian/Cohomology/BasicOpenCech.lean, severity=error)
```
Expected: empty list.
