# Refactor Directive

## Slug
cechcoface-named-family

## Problem

`cechCofaceMap_pi_smul` (L640+ of
`AlgebraicJacobian/Cohomology/BasicOpenCech.lean`) has been stalled at its
trailing per-summand R-linearity discharge across **four consecutive
prover lanes** (iter-099, iter-100, iter-101, iter-103). The latest
post-iter-103 frame at L827 is:

```
⊢ (ConcreteCategory.hom (((-1) ^ ↑i • Pi.lift_thing_i) ≫ eqToHom ⋯ ≫ Pi.π Z₂ j'))
     (e₁.symm (r' • y'))
  = r' • (ConcreteCategory.hom (((-1) ^ ↑i • Pi.lift_thing_i) ≫ eqToHom ⋯ ≫ Pi.π Z₂ j'))
     (e₁.symm y')
```

where the inner morphism is

```
Pi.lift_thing_i = Pi.lift fun i_1 ↦
  Pi.π (fun j ↦ ModuleCat.of k ↑(C.left.presheaf.obj (Opposite.op (∏ᶜ basicOpenCover ↑s₀ ∘ j))))
       (i_1 ∘ ⇑(SimplexCategory.δ i).toOrderHom)
  ≫ (toModuleKPresheaf C).map
       (Pi.lift fun x ↦ Pi.π (basicOpenCover ↑s₀ ∘ i_1) ((SimplexCategory.δ i).toOrderHom x)).op
```

Root cause (now fully characterised after iter-103's exhaustive
attempt log archived at
`logs/iter-102/prover-iter103-BasicOpenCech-report.md`):

- **Discrimination-tree blocker on `Pi.lift fun i_1 ↦ <body referencing outer i>`.**
  Lean's `simp`/`rw` pattern matcher cannot match scalar-extraction
  lemmas (`Preadditive.zsmul_comp`, `ModuleCat.hom_zsmul`, etc.) when the
  morphism's RHS contains a `Pi.lift` with an anonymous closure body
  that references the outer summation index `i`. Six routes failed at
  iter-101; five more failed at iter-103 including the iter-103 plan's
  `show`-pivot def-eq route.
- **whnf heartbeat timeout on alternatives.** `show` with literal Pi.lift
  body hit deterministic `whnf` timeout at 1600000 heartbeats; iter-102's
  refactor lane that rewrote the call site to use the σ-binder lemma
  `alternating_zsmul_pi_smul_aux_sum_comp` (introduced same iter, at
  L539-L590; body now closed by iter-103) timed out at 12800000
  heartbeats due to Miller-pattern unification on the anonymous closure.

The class of failures is structural: tactic-only routes on the existing
call site cannot extract `(-1)^↑i •` from the Pi.lift closure form.

## Mathematical Justification

The morphism family `Pi.lift_thing_i` is the i-th *sign-free* Čech coface
component, mapping `(∏ᶜ Z₁) → (∏ᶜ Z₂)` where:

- `Z₁ = fun (j : Fin ((ComplexShape.up ℕ).prev n + 1) → ↑s₀) ↦
       ModuleCat.of k ↑(C.left.presheaf.obj (Opposite.op (∏ᶜ basicOpenCover ↑s₀ ∘ j)))`
- `Z₂ = fun (j : Fin (n + 1) → ↑s₀) ↦
       ModuleCat.of k ↑(C.left.presheaf.obj (Opposite.op (∏ᶜ basicOpenCover ↑s₀ ∘ j)))`

The full Čech differential at degree `(prev n, n)` is the alternating sum
`∑ i ∈ Finset.univ, (-1)^↑i • (Pi.lift_thing_i ≫ eqToHom_witness)`, where
`eqToHom_witness` bridges the `Fin ((prev n) + 1) = Fin n+1` indexing
mismatch (witnessed by the local `hRel : (ComplexShape.up ℕ).prev n + 1 = n`).

The reason the existing tactic chain fails: Lean's discrimination tree
indexes on syntactic head symbols. When the family `G i` (the iter-099
`_sum_comp` lemma's family slot) is filled via Miller-pattern
unification with `fun i ↦ (-1)^↑i • <Pi.lift closure>`, the `simp`/`rw`
machinery for scalar-extraction lemmas cannot recognise `(-1)^↑i •
<closure>` as matching `(?n • ?f)` because the closure's nested-i body
prevents the pre-filter step.

**The fix.** Extract `Pi.lift_thing` (the sign-free family) as a
**top-level named definition** with explicit dependent indexing. Once
named, applying the existing iter-102 σ-binder lemma
`alternating_zsmul_pi_smul_aux_sum_comp` with this *explicit* family
(no Miller unification on the G slot) bypasses both the discrimination-
tree blocker (the family has a constant head symbol) and the heartbeat
cost (the elaborator no longer needs to unify the closure).

Additionally, the per-summand R-linearity hypothesis `hG` in the call
site reduces to a top-level theorem about the named family, which is
provable at the binder level via `Pi.lift_π_apply` +
`presheafMap_restrict_collapse` (the iter-087 R-linearity restriction-
collapse lemma at L425).

The mathematical content is unchanged: same Čech differential, same
R-linearity. Only the syntactic structure of the proof is rerouted to
avoid the discrim-tree failure.

## Changes Requested

### Change 1 — insert top-level definition `cechCofaceMap_summand_family`

Insert immediately after `presheafMap_restrict_collapse` (current L432;
shift by current file lines). The definition extracts the sign-free
Pi.lift closure into a named family.

**File**: `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`

**Proposed signature** (refactor agent may adjust universe parameters and
implicit/explicit splits to make it well-typed; the body must be `rfl`-
equivalent to the Pi.lift closure shape seen in the L827 goal):

```lean
/-- Iter-104 refactor: extracted top-level family for the sign-free
Čech coface morphism components. The body is the `Pi.lift fun i_1 ↦ ...`
expression that appears (anonymously) in the post-iter-099 expanded
Čech differential inside `cechCofaceMap_pi_smul`.

Naming this family makes the head symbol a defined constant rather than
an anonymous closure, which unblocks the iter-099 `_sum_comp` /
`alternating_zsmul_pi_smul_aux_sum_comp` call-site application:
- Miller unification on the G slot becomes trivial (G is given explicitly).
- The per-summand R-linearity hypothesis is a separate top-level theorem
  (`cechCofaceMap_summand_family_R_linear` below) that proves R-linearity
  of the named family at the binder level (HOU-free).
-/
def cechCofaceMap_summand_family
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {U : TopologicalSpace.Opens C.left.toTopCat}
    (s₀ : Finset ↑Γ(C.left, U)) (n : ℕ)
    (i : Fin ((ComplexShape.up ℕ).prev n + 2)) :
    (∏ᶜ fun j : Fin ((ComplexShape.up ℕ).prev n + 1) → ↑s₀ ↦
        ModuleCat.of k
          ↑(C.left.presheaf.obj
            (Opposite.op (∏ᶜ basicOpenCover ↑s₀ ∘ j)))) ⟶
    (∏ᶜ fun j : Fin (n + 1) → ↑s₀ ↦
        ModuleCat.of k
          ↑(C.left.presheaf.obj
            (Opposite.op (∏ᶜ basicOpenCover ↑s₀ ∘ j)))) :=
  Pi.lift fun i_1 : Fin (n + 1) → ↑s₀ ↦
    Pi.π (fun j : Fin ((ComplexShape.up ℕ).prev n + 1) → ↑s₀ ↦
            ModuleCat.of k
              ↑(C.left.presheaf.obj
                (Opposite.op (∏ᶜ basicOpenCover ↑s₀ ∘ j))))
        (i_1 ∘ ⇑(SimplexCategory.Hom.toOrderHom (SimplexCategory.δ i))) ≫
      (toModuleKPresheaf C).map
        (Pi.lift fun x : Fin ((ComplexShape.up ℕ).prev n + 1) ↦
            Pi.π (basicOpenCover ↑s₀ ∘ i_1)
              ((SimplexCategory.Hom.toOrderHom (SimplexCategory.δ i)) x)).op
```

**Note on the dependent typing**: the `Fin ((ComplexShape.up ℕ).prev n
+ 1)` in the source of `Pi.lift_thing_i` and in the inner `Pi.lift fun x
↦ ...` is what gets bridged to `Fin n` via `hRel` and `eqToHom` at the
call site. **Do NOT inline `hRel` into the definition.** Leave the
indexing explicit so the call site's `eqToHom` slot (which lives in the
`E` parameter of `alternating_zsmul_pi_smul_aux_sum_comp`) handles the
bridge. This keeps `cechCofaceMap_summand_family` independent of `hn`
(it does not need `0 < n`).

**Verify after insertion**: `lake env lean` should accept this
definition. If the unifier struggles, set
`set_option pp.all true` locally to compare the inserted body against
the L827 goal's Pi.lift expression.

### Change 2 — insert top-level theorem `cechCofaceMap_summand_family_R_linear`

Insert immediately after the new definition. The body is `sorry` — the
iter-105 prover fills it.

**Proposed signature**:

```lean
/-- Iter-104 refactor: per-summand R-linearity of the sign-free Čech
coface component `cechCofaceMap_summand_family`. The R-action on the
domain (`∏ᶜ Z₁`-side) is the Pi.module structure with each factor's
restriction-algebra structure; the R-action on the codomain (`∏ᶜ Z₂`-
side) is similarly the Pi.module structure with each factor's
restriction-algebra structure. The morphism factors through
`Pi.π Z_pre (i_1 ∘ δ i) ≫ presheaf.map _.op`, so R-linearity follows
per coordinate from `presheafMap_restrict_collapse` (L425) +
`Pi.lift_π_apply`.

Body left as `sorry` for the iter-105 prover. Proof sketch (~10-15 LOC):
1. `intro r y`.
2. `apply LinearMap.ext`; `intro j`.   [goal: per-coordinate R-linearity]
3. `simp only [Pi.lift_π_apply, ConcreteCategory.comp_apply, ...]`.
4. The composite at output coord `j` reads `(presheaf.map _).hom
   (y (j ∘ δ i))`. R-linearity follows from `presheafMap_restrict_collapse`.
-/
theorem cechCofaceMap_summand_family_R_linear
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {U : TopologicalSpace.Opens C.left.toTopCat}
    (hU : IsAffineOpen U)
    (s₀ : Finset ↑Γ(C.left, U)) (n : ℕ) (hn : 0 < n)
    (i : Fin ((ComplexShape.up ℕ).prev n + 2)) :
    let R := Γ(C.left, U)
    let Z₁ : (Fin ((ComplexShape.up ℕ).prev n + 1) → ↑s₀) → ModuleCat.{u} k :=
      fun i ↦ ModuleCat.of k
        ↑(C.left.presheaf.obj (Opposite.op (∏ᶜ basicOpenCover ↑s₀ ∘ i)))
    let Z_int : (Fin (n + 1) → ↑s₀) → ModuleCat.{u} k :=
      fun i ↦ ModuleCat.of k
        ↑(C.left.presheaf.obj (Opposite.op (∏ᶜ basicOpenCover ↑s₀ ∘ i)))
    -- module instances on the Pi domains, via Pi.module + RingHom.toModule
    letI perI₁ : ∀ i, Module R (Z₁ i) := fun i => by
      apply RingHom.toModule
      refine (C.left.presheaf.map (homOfLE ?_).op).hom
      let a0 : Fin ((ComplexShape.up ℕ).prev n + 1) := ⟨0, by omega⟩
      have h1 : ∏ᶜ (fun a => basicOpenCover (C := C) (U := U) ↑s₀ (i a)) ≤
        basicOpenCover (C := C) (U := U) ↑s₀ (i a0) := (Pi.π _ a0).le
      have h2 : basicOpenCover (C := C) (U := U) ↑s₀ (i a0) ≤ U :=
        basicOpen_le C.left (i a0 : Γ(C.left, U))
      exact h1.trans h2
    letI h_mod_pi₁ : Module R (∀ i, Z₁ i) := Pi.module _ _ _
    letI perI_int : ∀ i, Module R (Z_int i) := fun i => by
      apply RingHom.toModule
      refine (C.left.presheaf.map (homOfLE ?_).op).hom
      let a0 : Fin (n + 1) := ⟨0, by omega⟩
      have h1 : ∏ᶜ (fun a => basicOpenCover (C := C) (U := U) ↑s₀ (i a)) ≤
        basicOpenCover (C := C) (U := U) ↑s₀ (i a0) := (Pi.π _ a0).le
      have h2 : basicOpenCover (C := C) (U := U) ↑s₀ (i a0) ≤ U :=
        basicOpen_le C.left (i a0 : Γ(C.left, U))
      exact h1.trans h2
    letI h_mod_pi_int : Module R (∀ i, Z_int i) := Pi.module _ _ _
    let e₁ : (∏ᶜ Z₁ : ModuleCat.{u} k) ≃ₗ[k] (∀ i, Z₁ i) :=
      (ModuleCat.piIsoPi Z₁).toLinearEquiv
    let e_int : (∏ᶜ Z_int : ModuleCat.{u} k) ≃ₗ[k] (∀ i, Z_int i) :=
      (ModuleCat.piIsoPi Z_int).toLinearEquiv
    ∀ (r : R) (y : ∀ i, Z₁ i),
      e_int ((cechCofaceMap_summand_family s₀ n i).hom (e₁.symm (r • y))) =
        r • e_int ((cechCofaceMap_summand_family s₀ n i).hom (e₁.symm y)) :=
  sorry
```

**Note**: this signature reuses the `letI` reconstruction pattern from
`cechCofaceMap_pi_smul` so that the R-action definitions match
definitionally what the call site needs. The refactor agent may adjust
the exact `letI` block to match the call-site expectations (e.g., if
`alternating_zsmul_pi_smul_aux_sum_comp`'s instance arguments expect a
different shape).

**Body is `sorry`.** The iter-105 prover will close it (~15 LOC at the
binder level — HOU-free because `cechCofaceMap_summand_family` is named).

### Change 3 — rewrite the call site in `cechCofaceMap_pi_smul`

Currently at L791-L827 of `BasicOpenCech.lean` the call site reads:

```lean
  rw [← Pi.smul_apply (i := j)]
  refine congrFun
    (alternating_sum_pi_smul_aux_sum_comp Z₁ _ Z₂ Finset.univ _ _ e₁ e₂ ?_ r y) j
  -- iter-099 hG: per-summand R-linearity ...
  -- Iter-102 PLAN NOTE: ...
  intro i _ r' y'
  simp only [ModuleCat.hom_comp, LinearMap.comp_apply]
  funext j'
  -- iter-101 S1-S3 cumulative chain landed ...
  simp only [Pi.smul_apply]                                            -- S1
  show (CategoryTheory.ConcreteCategory.hom (Limits.Pi.π Z₂ j')) _ =
      r' • (CategoryTheory.ConcreteCategory.hom (Limits.Pi.π Z₂ j')) _ -- S2
  rw [show ModuleCat.Hom.hom = ConcreteCategory.hom (C := ModuleCat.{u} k) from rfl,
      show ModuleCat.Hom.hom = ConcreteCategory.hom (C := ModuleCat.{u} k) from rfl,
      ← ConcreteCategory.comp_apply, ← ConcreteCategory.comp_apply,
      ← ConcreteCategory.comp_apply, ← ConcreteCategory.comp_apply]    -- S3
  -- Post-S3 sorry: iter-103 prover takes over.
  rw [show (ConcreteCategory.hom : _ → _) = ModuleCat.Hom.hom from rfl] -- S4
  simp only [ModuleCat.hom_comp, LinearMap.comp_apply]                  -- S5
  sorry
```

**Rewrite to**:

```lean
  rw [← Pi.smul_apply (i := j)]
  refine congrFun
    (alternating_zsmul_pi_smul_aux_sum_comp
      (R := R) Z₁ _ Z₂ Finset.univ
      (fun i ↦ (-1)^(↑i : ℕ))
      (cechCofaceMap_summand_family s₀ n)
      _ e₁ e₂ ?_ r y) j
  -- Per-summand R-linearity discharge via the new top-level theorem.
  -- The hypothesis is about the sign-free composite `G i ≫ E`,
  -- where E := eqToHom (the Fin-indexing witness). After applying the
  -- summand family's R-linearity (`cechCofaceMap_summand_family_R_linear`),
  -- the eqToHom layer is absorbed via congruence on the codomain.
  intro i _ r' y'
  -- The goal here has shape
  --   e₂ ((cechCofaceMap_summand_family s₀ n i ≫ eqToHom _).hom (e₁.symm (r' • y')))
  --     = r' • e₂ ((cechCofaceMap_summand_family s₀ n i ≫ eqToHom _).hom (e₁.symm y'))
  -- Bridge to `cechCofaceMap_summand_family_R_linear` via:
  --   rw [ModuleCat.hom_comp, LinearMap.comp_apply, LinearMap.comp_apply]
  --   -- Now the eqToHom is INSIDE the e₂ application on both sides.
  --   -- e₂ ∘ eqToHom.hom is naturally linear (eqToHom is a LinearEquiv-like).
  --   exact cechCofaceMap_summand_family_R_linear hU s₀ n hn i r' y'
  --
  -- Refactor agent: if the bridge doesn't close cleanly, leave a `sorry`
  -- here for the iter-105 prover. The directive does NOT require the
  -- bridge to close at refactor time — only the structural rewrite to
  -- the named family.
  sorry
```

**Critical constraints on the rewrite**:

1. **Pass G *explicitly* via `cechCofaceMap_summand_family s₀ n`** (a named
   constant, no Miller unification). This is THE point of the refactor —
   it eliminates the anonymous-closure pattern that broke iter-099/100/101/103
   and the iter-102 call-site rewrite.

2. **Pass σ *explicitly* via `fun i ↦ (-1)^(↑i : ℕ)`**. The σ-binder is the
   sign extraction the new lemma handles at the binder level.

3. **Leave E and Z_int slots as Miller `_`**. E will be filled with `eqToHom
   ⋯` for the Fin-indexing witness; this is the *one* anonymous
   closure that's still needed, but its body is simple (just type-bridging
   the Fin index, no nested-i Pi.lift) and Miller should succeed in low
   heartbeats.

4. **The `?hG` discharge becomes a separate `sorry`** — the iter-105 prover
   chains `ModuleCat.hom_comp` + `LinearMap.comp_apply` + the eqToHom
   handling, then applies `cechCofaceMap_summand_family_R_linear`.

5. **Preserve byte-for-byte the prelude through L789** (everything before
   the iter-099 `rw [← Pi.smul_apply (i := j)]` line). This includes
   the iter-092 letI reconstruction, funext j, dsimp+simp chain, the B1
   bridge at L780, key₁/key₂ have-blocks, etc. Only L791-L827 changes.

6. **Strip all iter-101/iter-103 commentary blocks at L795-L803 and
   L810-L826** — they're informational and refer to dead routes
   (S1-S5 chain on the iter-099 _sum_comp shape, which is replaced).

7. **Keep `set_option maxHeartbeats 1600000`** as is. The refactor should
   NOT need to raise this — the whole point is that named G removes the
   heartbeat cost.

## Affected Files

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` — the only file
  touched. New definition + new theorem (body sorry) inserted at
  approximately L432 (after `presheafMap_restrict_collapse`); call site
  at L791-L827 rewritten as described.

## Expected Outcome

- **File compiles** (`lean_diagnostic_messages` severity=error returns `[]`).
- **Sorry count**: 6 → 7 net.
  - L827 sorry (`cechCofaceMap_pi_smul` trailing) → replaced by the
    new `?hG` sorry at the new call site (count: ±0).
  - **+1** sorry from new `cechCofaceMap_summand_family_R_linear` body.
  - Other sorries (L919, L1243, L1271, L1461, L1490) unchanged.
- **No new axioms.**
- **No protected signatures touched** (BasicOpenCech.lean has none).
- **Heartbeat budget** unchanged (1600000 for the
  `cechCofaceMap_pi_smul` block).
- **New top-level declarations** searchable via `grep -n '^def
  cechCofaceMap_summand_family\|^theorem cechCofaceMap_summand_family_R_linear'`.

## Fallback if call-site rewrite breaks compilation

If Change 3 fails to compile (e.g., the
`alternating_zsmul_pi_smul_aux_sum_comp` application Miller-unifies the
E slot into an unexpected eqToHom shape and the cascading goal differs
from the expected `cechCofaceMap_summand_family s₀ n i ≫ E` form),
**leave the L791-L827 chain UNCHANGED** and only commit Changes 1 and 2.

In that fallback case, the iter-105 prover gets:
- The new infrastructure (`cechCofaceMap_summand_family` + R-linearity
  theorem skeleton) available as named handles.
- The L827 sorry still there in the original iter-099-_sum_comp shape.
- A clearer route forward: prove `cechCofaceMap_summand_family_R_linear`
  first (binder-level, HOU-free), THEN attempt the call-site rewrite
  with the proven R-linearity as `?hG`.

Expected sorry count in fallback: 6 → 8 (L827 still + L590-area new
theorem body + ... wait, no — fallback adds only +1 from the new R-linear
theorem body, since L590 (zsmul_aux_sum_comp) was already closed iter-103).
So fallback: 6 → 7.

In either case, **FILE MUST COMPILE**.

## Verification checklist for the refactor agent

After making the changes:

1. `mcp__archon-lean-lsp__lean_diagnostic_messages` with `severity=error`
   returns `[]`.
2. `${LEAN4_PYTHON_BIN:-python3} "$LEAN4_SCRIPTS/sorry_analyzer.py"
   AlgebraicJacobian/Cohomology/BasicOpenCech.lean --format=summary`
   reports the expected count (7 if all 3 changes applied; 7 if fallback).
3. `lean_local_search` for `cechCofaceMap_summand_family` finds the new def.
4. `lean_local_search` for `cechCofaceMap_summand_family_R_linear` finds
   the new theorem.
5. The new declarations have no protected-signature conflicts.

## What the refactor agent must NOT do

- **Do NOT modify the iter-097/098/099/102 lemmas**: `alternating_sum_pi_smul_aux`
  (L462-L494), `alternating_sum_pi_smul_aux_sum_comp` (L513-L537),
  `alternating_zsmul_pi_smul_aux_sum_comp` (L539-L609, now closed body).
  These are the load-bearing infrastructure the call site uses.
- **Do NOT modify `presheafMap_restrict_collapse`** (L425, fully proved iter-087).
- **Do NOT modify the `cechCofaceMap_pi_smul` SIGNATURE** (L640-660).
- **Do NOT modify the body prelude through L789** of `cechCofaceMap_pi_smul`.
- **Do NOT add any axioms.**
- **Do NOT delete any existing sorries** other than L827.

## Background context (for the refactor agent)

This is the 5th major intervention on the same residual after iter-099,
iter-100, iter-101, iter-102 (refactor pair), and iter-103. The streak-
escalation criterion has been triggered. Plan-agent and prover
diagnostics across these iterations agree on the root cause
(discrimination-tree blocker on `Pi.lift fun i_1 ↦ <body with outer i>`)
and on the route (named family + binder-level R-linearity proof). This
is the documented Path C in `PROGRESS.md` § "Path C — top-level R-linear
composite helper".

Iter-102's earlier refactor pair (slugs `alt-zsmul-pi-smul-aux-sum-comp`
+ `alt-zsmul-restore-compile`) inserted the σ-binder lemma
`alternating_zsmul_pi_smul_aux_sum_comp` but the call-site application
failed at 12800000 heartbeats due to Miller unification on the
anonymous-closure G slot. This refactor finishes the iter-102 work by
NAMING G — eliminating the Miller-pattern unification.
