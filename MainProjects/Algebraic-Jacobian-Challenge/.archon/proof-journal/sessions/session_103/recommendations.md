# Recommendations for the next plan-agent iteration (iter-106)

## CRITICAL — streak-escalation rule (3rd trigger over `cechCofaceMap_pi_smul` slot)

This is the **5th consecutive substantive prover lane** on
`cechCofaceMap_pi_smul`'s per-summand `hG` discharge
(iter-099/100/101/103/105 in project-narrative); iter-102 + iter-104 were
refactor lanes. The slot has resisted full closure across all five lanes
despite landing durable structural advances every iter.

**However**: the iter-105 residual is **NOT the discrim-tree blocker**
that defeated iter-099/100/101/103. The wrapper helpers
(`cechCofaceMap_summand_family'` + `cechCofaceMap_summand_family'_R_linear`)
are now committed and fully proved. **The remaining gap is purely
morphism-level eqToHom-vs-Pi.π transport** at coordinate `j'` — a clean,
self-contained problem.

**Mandate for iter-106**: commit to ONE morphism-level route (the prover's
own recommendations enumerate three; pick exactly one and follow it
through). **NO further raw-tactic passes** on the L1147 goal in its
current frame. The current frame has been probed exhaustively.

## Recommended target — iter-106 plan should prioritise

### Primary — `cechCofaceMap_pi_smul` at L1147 of BasicOpenCech.lean

Three concrete routes, in order of cleanliness and likely viability:

#### Route 1 — Top-level morphism-equality lemma (RECOMMENDED, primary)

Add a top-level lemma between Helper 1 and Helper 2 (so it can be
invoked before the R-linearity transport):

```lean
/-- Iter-106 transport: the named family composed with the index-equality
eqToHom equals the `Fin (n + 1)`-indexed wrapper at the `Fin.cast`'d
input. -/
theorem cechCofaceMap_summand_family_comp_eqToHom_eq
    {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {U : TopologicalSpace.Opens C.left.toTopCat}
    (s₀ : Finset Γ(C.left, U)) (n : ℕ) (hn : 0 < n)
    (i : Fin (n + 1))
    (hRel' : (ComplexShape.up ℕ).prev n + 2 = n + 1)
    (hEq : ...eqToHom-codomain-equality...) :
    cechCofaceMap_summand_family s₀ n (Fin.cast hRel'.symm i) ≫
      eqToHom hEq =
    cechCofaceMap_summand_family' s₀ n hn i := by
  apply Limits.Pi.hom_ext  -- or: limit.hom_ext
  intro j_new
  simp only [Category.assoc, Limits.Pi.lift_π, eqToHom_trans, ...]
  -- per-coord goal reduces to:
  --   Pi.π _ (j_new ∘ Fin.cast hRel.symm.symm ∘ δ_(Fin.cast hRel ...).toOrderHom) ≫
  --     (presheaf.map _).op =
  --   Pi.π _ ((j_new ∘ Fin.cast hRel) ∘ δ_(Fin.cast hRel.symm i).toOrderHom) ≫
  --     (presheaf.map _).op
  -- modulo Fin.cast_cast round-trip: Fin.cast hRel.symm (Fin.cast hRel i) = i.
  congr 1
  · funext j_new
    rw [Fin.cast_cast, Fin.cast_eq_self]  -- the round-trip identity
  · rfl
```

Once this lemma lands, the L1147 proof body becomes (~12 LOC):

```lean
  have hRel' : (ComplexShape.up ℕ).prev n + 2 = n + 1 := by omega
  have h_morph_eq := cechCofaceMap_summand_family_comp_eqToHom_eq s₀ n hn
    (Fin.cast hRel' i) hRel' ?_
  -- pull (-1)^↑i • out via ModuleCat.hom_zsmul + map_zsmul
  rw [show ((-1 : ℤ)^↑i • cechCofaceMap_summand_family ...) ≫ eqToHom _ =
       (-1 : ℤ)^↑i • cechCofaceMap_summand_family_comp_eqToHom_eq.. from
       by rw [Preadditive.zsmul_comp]]
  -- now apply h_morph_eq for the eqToHom-free wrapper form
  rw [h_morph_eq]
  -- now apply cechCofaceMap_summand_family'_R_linear + smul_comm
  ...
```

**Why Route 1**: cleanest morphism-level move; reusable for any future
file-internal Pi-codomain transport; one new top-level lemma; the proof
relies on the binder-level `Pi.hom_ext` + `Pi.lift_π` pattern that's
clean of discrim-tree blockers. **Estimated LOC: ~25 for the lemma + ~12
to close L1147; ~40 LOC total.**

#### Route 2 — rcases-on-n + simp before the wrapper invocation (FALLBACK)

```lean
  rcases n with _ | m
  · exact absurd hn (lt_irrefl 0)
  -- now n = m + 1; ComplexShape.prev (m + 1) reduces to m
  simp only [show (ComplexShape.up ℕ).prev (m + 1) = m from
    by simp [ComplexShape.prev, ComplexShape.up_Rel]] at *
  -- now the eqToHom's source/target indices coincide (Fin (m + 2) = Fin (m + 2));
  -- eqToHom of refl is identity
  -- iter-105 attempt 4 reported `simp at *` doesn't fully collapse this; iter-106
  -- may need stronger simp set: try `eqToHom_refl`, `Category.id_comp`, `Category.comp_id`.
```

Iter-105 attempt 4 probed this route and `simp at *` did not fully
collapse eqToHom. **Iter-106 should retry with a stronger simp set
(`[eqToHom_refl, Category.id_comp, Category.comp_id, Fin.cast_refl]`)
and a follow-up `rfl` / `convert` to close the residual.**

#### Route 3 — `convert h_wrap_pt using 3` (most direct)

After the iter-105 partial proof at L1126–L1147 already has `h_wrap_pt`
in context, append:

```lean
  convert h_wrap_pt using 3 with j_eq F_eq z_eq
  · -- per-coord eqToHom transport sub-goal LHS
    rw [Pi.lift_π_apply, Fin.cast_cast]
    rfl
  · -- per-coord eqToHom transport sub-goal RHS
    rw [Pi.lift_π_apply, Fin.cast_cast]
    rfl
  -- smul-commutativity sub-goal:
  rw [smul_comm]
```

**Caveat**: `convert using 3` may produce different sub-goal shapes than
predicted. The probe should be re-verified at LSP before commitment.
**Iter-106 should ONLY use this as last resort** — Route 1 is cleaner
because it isolates the per-coord transport into a reusable lemma.

### Plan-agent decision rule for iter-106

- **Path A (primary)**: Route 1 (top-level morphism-equality lemma).
  Estimated 1 substantive subagent dispatch (no refactor needed, just a
  new top-level theorem + body) OR direct prover lane on the new theorem
  + L1147 client proof. Hard cap: **6 attempts at LSP on the new lemma's
  body**; if all fail, fall back to Path B for iter-107.
- **Path B (fallback, iter-107 if Path A stalls)**: Route 2 (rcases-on-n
  with stronger simp set).
- **Path C (last resort, only if A + B both stall)**: Route 3.
- **DO NOT attempt** any raw-tactic combinator on the L1147 goal in its
  current form WITHOUT first applying one of the three routes — the
  discrim-tree blockers are exhausted.

## Deferred targets (do NOT assign iter-106)

### Off-limits this round
- `BasicOpenCech.lean` L1239 (was L1080): substep (a) augmented Čech
  infrastructure. Multi-iter blocker.
- `BasicOpenCech.lean` L1563 (was L1404): substep blocker.
- `BasicOpenCech.lean` L1591 (was L1432): substep (a) extra-degeneracy
  for s₀-indexed slice cover.
- `BasicOpenCech.lean` L1810 (was L1651): `h_loc_exact` —
  `IsLocalizedModule.Away f.1` infrastructure.
- `Differentials.lean` L122, L957, L974, L1116: multi-iter blockers.
- `Differentials.lean` L636 (`cotangentExactSeq_structure case h_exact`):
  Route A/B decision pending; deferred lane 2.
- `Modules/Monoidal.lean` L173: Mathlib upstream gap; off-limits since
  iter-081.
- `Jacobian.lean` L179: Phase C/E packaging; gated on Phase C C0–C3.
- `Picard/Functor.lean` L190: gated on Phase C C0–C3.

### Becomes ungated after L1147 closes
- `BasicOpenCech.lean` L1781 (`g_R.map_smul'`, was L1622): once
  `cechCofaceMap_pi_smul` closes, this slot's `(-1)^↑i •` analogue lifts
  to the next blueprint declaration; should be the iter-107 primary
  assuming iter-106 closes L1147.

## Reusable proof patterns discovered this iter (NEW or REINFORCED)

### Wrapper-via-direct-Pi.lift (NEW)

When bridging a Fin-index mismatch via a wrapper def, define as a direct
`Pi.lift` rather than `named_family ≫ eqToHom`. The direct form keeps
the binder-level R-linearity proof discrim-tree-clean (reusing iter-104
pattern); the alternative form re-introduces the discrim-tree blocker.
**Trade-off**: deferring the eqToHom transport burden into a single
client proof is much smaller than re-running the iter-099/100/101/103
wall.

### iter-104 R-linearity pattern as production template (REINFORCED)

`RingHom.toModule_smul` + `piIsoPi_inv_kernel_ι_apply` + term-level
`Eq.trans` + `congrArg` + `presheafMap_restrict_collapse` mirrored
byte-for-byte from iter-104 (L494) to iter-105 (L634) with only the
Fin.cast index translation differing. Confirmed across 2 invocations.

## Hard cap budget recommendation for iter-106

- **Sorry hard cap**: 6 (entry; can decrease by 1 if Route 1 closes
  L1147).
- **Sorry target**: 5 (close L1147 via Route 1).
- **Sorry stretch**: 4 (Route 1 closes L1147 AND inline `convert
  h_wrap_pt using 3` style move also closes L1781 `g_R.map_smul'`, which
  has a structurally similar shape).
- **Subagent budget**: 0–1 (Route 1 is a new top-level theorem, can be
  written by the prover; only invoke refactor if Route 1 needs
  cross-file plumbing).
- **Heartbeat budget**: default 800000 OK; the 12800000 bump from
  iter-102 has been reverted and iter-105 R-linearity body closed within
  default. Do NOT re-add the heartbeat bump.
