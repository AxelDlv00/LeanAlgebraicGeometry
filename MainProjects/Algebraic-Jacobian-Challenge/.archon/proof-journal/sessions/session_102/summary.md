# Session 102 — iter-102 review (project narrative iter-104)

## Metadata

- **Archon iteration**: 102 (= session_102)
- **Project-narrative label**: iter-104 (single substantive prover lane; close)
- **Iteration shape**: 1 prover lane on `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`
- **Sorry count before**: 15 (BasicOpenCech 7 — post iter-102-refactor; Differentials 5,
  Modules/Monoidal 1, Jacobian 1, Picard/Functor 1)
- **Sorry count after**: **14**. BasicOpenCech.lean: **7 → 6**. L536
  (`cechCofaceMap_summand_family_R_linear` body) closed via a 50-line
  body-local tactic proof at L536–L599.
- **Targets attempted**: Step 1 (`cechCofaceMap_summand_family_R_linear` body
  at L536) — PRIMARY. Step 2 (stretch — L929 `cechCofaceMap_pi_smul`
  trailing) — explicitly skipped per the plan's escalation rule (Step 1
  took ~25 LSP probes, exceeding the ~3-attempt threshold).
- **Compile-verified at close**: yes (`lean_diagnostic_messages` returns
  `[]` for severity=error end-to-end). **Tenth consecutive compile-verified
  prover iteration** (iter-092, iter-093, iter-094, iter-095, iter-097,
  iter-099, iter-100, iter-101, iter-103, iter-104).
- **Total file events** (per `attempts_raw.jsonl` summary): 120 events;
  2 edits; 2 goal checks; 3 diagnostic checks; 9 lemma searches; 0
  builds; 3 clean diagnostics; 0 errors.
- **Prover model**: Sonnet (via Archon harness on `iter-102/provers`).

## Target 1: `cechCofaceMap_summand_family_R_linear` body (L536) — SOLVED ✓

### Plan recipe (Path A from PROGRESS.md)

```
intro r y
unfold cechCofaceMap_summand_family
apply LinearMap.ext
intro j'
simp only [LinearEquiv.coe_coe, ModuleCat.piIsoPi_apply, Pi.lift_π_apply,
           ModuleCat.hom_comp, LinearMap.comp_apply]
simp only [map_smul, LinearEquiv.symm_apply_apply, ...]
exact presheafMap_restrict_collapse _ _ _ _
```

### Initial goal frame (verified via `lean_goal` at L536)

```
⊢ ∀ (r : R) (y : ∀ i, Z₁ i),
    e_int ((cechCofaceMap_summand_family s₀ n i).hom (e₁.symm (r • y))) =
      r • e_int ((cechCofaceMap_summand_family s₀ n i).hom (e₁.symm y))
```

where `R = Γ(C.left, U)`, `Z₁/Z_int` are the per-coordinate ModuleCat
objects, `e₁/e_int = (ModuleCat.piIsoPi ...).toLinearEquiv`, and the
R-module structure on the Pi codomains is via `Pi.module +
RingHom.toModule (presheaf.map ...)`. The morphism unfolds to a
`Pi.lift fun i_1 ↦ Pi.π Z₁ ∘ presheaf.map _` shape — but the head is
now a NAMED constant `cechCofaceMap_summand_family s₀ n i` (key
property of the iter-102 refactor).

### Attempt 1 — `intro r y; funext j'; sorry` (probe goal shape)

- **Tactic**: `intro R Z₁ Z_int e₁ e_int r y; funext j'; sorry`
- **Method**: `lean_multi_attempt` probe.
- **Result**: goal at `j'` reads
  `e_int ((cechCofaceMap_summand_family s₀ n i).hom (e₁.symm (r • y))) j' =
   (r • e_int ((cechCofaceMap_summand_family s₀ n i).hom (e₁.symm y))) j'`
  — confirms post-funext frame.
- **Insight**: `funext j'` lands cleanly post-intro; no LinearMap.ext
  detour needed.

### Attempt 2 — Add `simp only [Pi.smul_apply]`

- **Tactic**: post-funext `simp only [Pi.smul_apply]` to distribute
  the outer `r •` on the RHS into per-coord.
- **Result**: SUCCESS — RHS now `r • e_int ((... .hom (e₁.symm y)) j'`.

### Attempt 3 — `rw [piIsoPi_hom_ker_subtype_apply Z_int j']`

- **Tactic**: `rw [← ModuleCat.piIsoPi_hom_ker_subtype_apply Z_int j',
  ← ModuleCat.piIsoPi_hom_ker_subtype_apply Z_int j']`
- **Result**: FAILED — "did not find an occurrence". Same blocker
  as iter-099/103: the LinearEquiv coercion in `e_int = (piIsoPi
  Z_int).toLinearEquiv` masks the discrimination key for the
  `(piIsoPi).hom` lemma form.
- **Workaround chosen**: pivot via `show (Pi.π Z_int j').hom
  ((cechCofaceMap_summand_family s₀ n i).hom (e₁.symm (r • y))) = r •
  (Pi.π Z_int j').hom ((cechCofaceMap_summand_family s₀ n i).hom
  (e₁.symm y))` — definitional equality on the LHS that puts `Pi.π
  Z_int j'` explicitly into the head.

### Attempt 4 — Unfold the named family

- **Tactic**: `unfold cechCofaceMap_summand_family` then `simp only
  [Limits.Pi.lift_π_apply, ConcreteCategory.comp_apply]`.
- **Result**: SUCCESS — the named constant unfolds; `Pi.lift_π_apply`
  fires cleanly because the head is now a constant (not an anonymous
  closure). This vindicates the iter-102 refactor design hypothesis:
  the discrim-tree blocker is at the smul-Pi.lift interface, not at
  the morphism level when the family is named.

### Attempts 5–12 — Multi-probe exploration of post-Pi.lift_π frame

Multiple `lean_multi_attempt` probes (visible in `attempts_raw.jsonl`
lines 76–96, 156–200) explored variations of post-Pi.lift_π goal-shaping
before settling on the term-level pattern. The prover spent significant
LSP-probing wallclock (~25 probes) verifying the framing of:
- the `letI perI₁/perI_int/h_mod_pi_*` body-local instance reconstruction
- the dichotomy between `e₁.symm` as ModuleCat morphism vs LinearEquiv coe
- the `RingHom.toModule_smul` rfl rewrite
- the term-level `Eq.trans + congrArg` finisher

### Attempt 13 — Add `letI` reconstruction inside body

- **Insight**: the signature's `letI perI₁/perI_int/h_mod_pi_*` bindings
  do NOT survive `intro` into the goal frame in a way that the `r • y`
  HSMul re-synthesises against the goal's elaborated `Pi.module`.
  Reconstructing them inside the tactic body is mandatory — this
  mirrors the pattern at L781–L805 of `cechCofaceMap_pi_smul`
  (iter-092 foundation repair).
- **Tactic**: 4 explicit `letI perI₁/perI_int/h_mod_pi_₁/h_mod_pi_int`
  reconstructions immediately after `intro R Z₁ Z_int e₁ e_int`.

### Attempt 14 (FINAL committed body) — full 50-line proof

```lean
theorem cechCofaceMap_summand_family_R_linear ... := by
  intro R Z₁ Z_int e₁ e_int
  letI perI₁ : ∀ i, Module R (Z₁ i) := fun i => by
    apply RingHom.toModule
    refine (C.left.presheaf.map (homOfLE ?_).op).hom
    let a0 : Fin ((ComplexShape.up ℕ).prev n + 1) := ⟨0, by omega⟩
    ... -- ≤-chain via `homOfLE` (~6 lines)
  letI h_mod_pi₁ : Module R (∀ i, Z₁ i) := Pi.module _ _ _
  letI perI_int : ∀ i, Module R (Z_int i) := fun i => by ...
  letI h_mod_pi_int : Module R (∀ i, Z_int i) := Pi.module _ _ _
  intro r y
  funext j'
  simp only [Pi.smul_apply]
  show (Pi.π Z_int j').hom ((cechCofaceMap_summand_family s₀ n i).hom
      (e₁.symm (r • y))) =
    r • (Pi.π Z_int j').hom ((cechCofaceMap_summand_family s₀ n i).hom
      (e₁.symm y))
  unfold cechCofaceMap_summand_family
  simp only [Limits.Pi.lift_π_apply, ConcreteCategory.comp_apply]
  have hSym : ∀ (Z : ...) (a : ...),
      (Pi.π Z₁ a).hom (e₁.symm Z) = Z a := by
    intro Z a; exact ModuleCat.piIsoPi_inv_kernel_ι_apply Z₁ a Z
  rw [hSym, hSym]
  simp only [Pi.smul_apply, RingHom.toModule_smul]
  set Pl : ... := Pi.lift fun x => Pi.π _ ((SimplexCategory.δ i).toOrderHom x)
    with hPl_def
  exact ((C.left.presheaf.map Pl.op).hom.map_mul _ _).trans
    (congrArg (· * (C.left.presheaf.map Pl.op).hom
        (y (j' ∘ (SimplexCategory.δ i).toOrderHom)))
      (presheafMap_restrict_collapse _ _ _ r))
```

### Key insights from Step 1 closure

1. **`letI` reconstruction inside body is mandatory** *(iter-104, REINFORCED)*.
   The signature's let-bound module instances don't survive `intro` into
   the goal frame in a way that `r • y` HSMul re-synthesises. Mirrors
   iter-092 foundation pattern at `cechCofaceMap_pi_smul` L781–L805.

2. **`piIsoPi_inv_kernel_ι_apply` is the inverse-form for `e₁.symm`**
   *(iter-104, NEW)*. Converting `(Pi.π Z₁ a).hom (e₁.symm Z) = Z a`
   requires the `inv` form (not `hom`) of the iso. The wrapper `hSym`
   works because `e₁.symm = (piIsoPi Z₁).inv.hom` definitionally.

3. **`RingHom.toModule_smul` is rfl** *(iter-104, NEW)*. Used as a
   simp lemma to expand both `r • _` actions on `Z₁` and `Z_int`
   (which are RingHom.toModule constructions) to explicit `f(r) * _`
   multiplication, exposing the underlying ring structure for the
   term-level finisher.

4. **Term-level `Eq.trans + congrArg` for the final step**
   *(iter-104, NEW workaround)*. Tactic-level `rw
   [(presheaf.map Pl.op).hom.map_mul]` failed across multiple variants
   (`change`, `generalize_proofs`, `set`, `show ... from ...`) because
   of HMul-synth issues on the W₂ output ring (despite W₁ HMul
   resolving fine). The term-level chain bypasses these issues
   entirely:
   - `(...).hom.map_mul _ _ : f(a * b) = f a * f b` (Eq #1)
   - `congrArg (· * f y_val) (presheafMap_restrict_collapse _ _ _ r)`
     proves `f(g₁ r) * f y_val = g₂ r * f y_val` (Eq #2)
   - `.trans` composes them into the goal.

5. **`set Pl := Pi.lift ... with hPl_def` is required** *(iter-104, NEW)*.
   Naming the inner `Pi.lift` gives `presheafMap_restrict_collapse`
   a target type that unifies with the implicit-arg metas; without
   the `set`, the `_` placeholders blow up trying to discover the
   source/target opens. **Caveat**: this `set` succeeds where the
   iter-099 `set Pi_lift_thing` failed because here the binding is on
   the *outer* `Pi` (in the W₂ side of `presheaf.map _`), not on the
   anonymous-closure codomain Pi.lift.

## Target 2: `cechCofaceMap_pi_smul` trailing sorry (was L827, now L988) — NOT ATTEMPTED

Per PROGRESS.md's escalation rule: "do NOT attempt Step 2 if Step 1 takes
more than ~3 attempts. Step 1 closure alone hits the iter-104 target
budget." Step 1 took ~25 LSP probes and a long term-level workaround
to close. The prover correctly skipped Step 2.

The L929 (now L988) trailing sorry remains for iter-105+. Infrastructure
is now in place:
- `cechCofaceMap_summand_family` (L454, named def, no sorry)
- `cechCofaceMap_summand_family_R_linear` (L494, **NOW FULLY PROVED**)
- `alternating_zsmul_pi_smul_aux_sum_comp` (L672, iter-103-closed)

The Fin-index mismatch (`Fin (n+1)` post-`dif_pos hRel` at call site vs
`Fin ((prev n) + 2)` on the new def) still blocks direct application —
the refactor agent's Route B recommendation (build a
`cechCofaceMap_summand_family' : Fin (n+1) → ...` wrapper via
`Fin.cast + eqToHom`) is now viable since the per-summand R-linearity
is in place.

## Sorry trajectory (post iter-104)

- **BasicOpenCech.lean**: 7 → **6** at L988, L1080, L1404, L1432, L1622,
  L1651 (verified via direct grep on tactic-position sorries — see
  Step 6 in this summary). Line numbers shifted by ~+52 vs iter-103
  close due to the 53-line proof body inserted at L536.
- **Differentials.lean**: 5 (unchanged) at L122, L636, L957, L974, L1116.
- **Modules/Monoidal.lean**: 1 at L173 (off-limits).
- **Jacobian.lean**: 1 at L179.
- **Picard/Functor.lean**: 1 at L190.
- **Total**: **14** (was 15). Target met (-1).

## Streak status — REVERSED

**The "5-iter substantive lane on `cechCofaceMap_pi_smul` hG slot"
streak is BROKEN this iter** (which was the iter-102 plan's design
intent, by switching the prover lane to the NEW L536 R-linearity
target after refactor produced an HOU-free binder frame).

Iter-099/100/101/103 all hammered the L827 (formerly L728/L768/L811)
hG slot directly. Iter-102 (plan-agent narrative iter-104 entry) did
a refactor pair (named family extraction + R-linearity skeleton).
**Iter-104 (this iter) targeted the new L536 R-linearity body and
closed it on the same lane** — vindicating the iter-102 refactor's
"close at the binder level, not the call site" hypothesis.

The L929 call-site trailing sorry remains for iter-105+, but with a
genuinely new escape route (Route A Fin transport or Route B wrapper
def) rather than another raw-tactic pass.

## Key findings (this session)

1. **Refactor-then-prove production loop continues to deliver**.
   Iter-102 named-family refactor + iter-104 R-linearity closure
   mirrors the iter-098 split-slot refactor + iter-099 _sum_comp
   bridge closure. Two-iter cadence: one refactor lane producing a
   structural HOU-free binder frame, then one prover lane closing
   the new body. **Pattern is now established as the project's
   primary technique for HOU-blocked targets.**

2. **`piIsoPi_inv_kernel_ι_apply` for the `e₁.symm` direction**
   *(NEW iter-104)*. Project-known L425-area infrastructure
   `presheafMap_restrict_collapse` pairs with the Mathlib
   `piIsoPi_inv_kernel_ι_apply` lemma to fully decompose Pi.lift +
   piIsoPi-symm composites at the per-coordinate level. The wrapper
   `hSym` is project-local and packs `e₁.symm = (piIsoPi Z₁).inv.hom`
   definitional equality into a 2-line `have`.

3. **`RingHom.toModule_smul` as a simp lemma** *(NEW iter-104)*. Use
   when a goal contains `r • _` where `_` lives in a Pi codomain
   whose R-module structure was built via `RingHom.toModule
   (presheaf.map _).hom`. Reduces `r • _` to `f(r) * _` via rfl,
   exposing the ring structure for downstream `map_mul`-style
   reasoning.

4. **Term-level `Eq.trans + congrArg` to bypass HMul-synth blockers**
   *(NEW iter-104)*. When `rw [h.map_mul]` fails because the HMul
   typeclass on the output ring fails to synthesise via `change` /
   `generalize_proofs` / `set` / `show ... from`, switch to term
   level: `h.map_mul a b : f(a*b) = f a * f b` composed via
   `.trans (congrArg ...)`. Project-local pattern; documented at
   L595–L598 in BasicOpenCech.lean.

## Blueprint markers updated (manual)

None this iteration. `cechCofaceMap_summand_family_R_linear` is a
project-local helper without its own `\lean{...}` entry in the
blueprint. The deterministic `sync_leanok` phase ran before this
review; no `\leanok` changes flowed from the L536 closure because
that decl has no blueprint entry.

## Tool usage (per `attempts_raw.jsonl` summary)

- 120 events, 1 prover session.
- 2 `Edit`s (the body insertion at L536, then the comment cleanup at
  L580ish).
- 1 `Write` (task_result Cohomology_BasicOpenCech.lean.md).
- 9 lemma searches (mix of `lean_local_search` + Bash grep).
- 3 `lean_diagnostic_messages` checks (all clean).
- 2 `lean_goal` checks (initial L536, post-Step-1 L588).
- ~20+ `lean_multi_attempt` probes (most of the wall time).
- 0 `lean_build`s.
- 0 errors at any diagnostic check.

## Confidence notes

- Step 1 closure verified via `lean_diagnostic_messages` returning `[]`
  at file save. Body compiles cleanly.
- Tactic correctness is best-of-Sonnet — the term-level finisher uses
  `congrArg (· * f y_val) (...)` which is a documented project pattern
  (cf. similar use at L425 `presheafMap_restrict_collapse` proof).
- No new axioms (`grep -n '^axiom' BasicOpenCech.lean` empty).
- No protected signatures touched.
- iter-102 refactor's `cechCofaceMap_summand_family` (L454) signature
  preserved byte-for-byte.

## Notes section (LOW-severity items)

- The prover spent a lot of wall time (~25 LSP probes) before
  converging on the `letI` reconstruction + term-level finisher.
  This is consistent with the project's iter-092 foundation discovery
  (letI in conclusion frame requires body reconstruction); future
  plan-agents could pre-state this in the directive to save the
  prover the rediscovery cost.
- No reviewer subagents dispatched (this was a pure proof-filling
  round on an existing skeleton; the iter-102 refactor was reviewed
  inline via the plan-agent's verification pass).
