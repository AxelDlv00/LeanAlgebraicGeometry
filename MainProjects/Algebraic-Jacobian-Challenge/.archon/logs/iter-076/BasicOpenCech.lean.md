# Cohomology/BasicOpenCech.lean — iter-076 repair lane

## Outcome

- **File compiles cleanly**: zero errors. The 5 errors flagged by the plan agent
  (L412 whnf timeout, L952 unsolved goals on `h_mod_X₃`, L1088 simp no progress,
  L1170–1171 application type mismatch, L1182 isDefEq timeout, plus the
  cascading L1205 unsolved goals + L1213 whnf timeout) are all resolved.
- **Sorry count**: 6 → **7** (within the plan's `≤ 9` budget; +1 over baseline).
- **No new axioms.**
- **No new project-local helper lemmas** (per user feedback policy).

## Sorries — old vs new mapping

Original 6 (before iter-076):
- L495 — substep (a) for `s` (slice-cover extra-degeneracy)
- L819 — kernel-π acyclicity (Step 3 of `h_transport`)
- L847 — substep (a) for `s₀`
- L1166 — h_diff_pi_smul_f's sign-free per-summand R-linearity
- L1181 — h_diff_pi_smul_g body
- L1260 — h_loc_exact (Step 4)

New 7 (after iter-076):
- L495 — unchanged
- L819 — unchanged
- L847 — unchanged
- L1077 — h_diff_pi_smul_f body (rolled back from the L1083+ chain)
- **L1106 — f_R.map_smul' body (NEW; was a `calc` chain that depended on `h_diff_pi_smul_f` + literal `Module R scK₀.X₁` instance equality)**
- **L1116 — g_R.map_smul' body (NEW)**
- L1145 — h_loc_exact (was L1260; line shift from edits above)

Removed: the entire `h_diff_pi_smul_g` declaration (its statement could not
type-check because `scK₀.X₃` does not reduce to `↑(∏ᶜ Z₃)` — see L952 analysis
below — and it was only used by `g_R.map_smul'`, which is now rolled back too).

## Per-error analysis

### L952 — `h_mod_X₃` unsolved `Module = Module` after `convert h`

**Root cause.** `scK₀.X₃ = (HomologicalComplex.sc K₀ n).X₃ = K₀.X
((ComplexShape.up ℕ).next n)`.  The `ComplexShape.next` function is **opaque**
(defined via `Classical.choose` over the `Rel` predicate), so `(ComplexShape.up
ℕ).next n` does **not** reduce to `n + 1` by `rfl` — you need
`CochainComplex.next` (Mathlib lemma: `(ComplexShape.up α).next i = i + 1`).
That's why `convert h` succeeds verbatim for X₁ and X₂ (whose `Fin` indices use
the literal `prev n + 1` / `n + 1`) but fails for X₃ (whose `Fin (next n + 1)`
index doesn't auto-reduce to match `Z₃`'s `Fin (n + 2)`).

**Repair (kept the iter-071/072 structural transport plan intact).**

```lean
have h_mod_X₃ : Module R scK₀.X₃ := by
  have h_eq : scK₀.X₃ = K₀.X (n + 1) := by
    show K₀.X ((ComplexShape.up ℕ).next n) = K₀.X (n + 1)
    rw [CochainComplex.next]
  rw [h_eq]
  dsimp [K₀, cechCochain, cechComplexFunctor, toModuleKSheaf, toModuleKPresheaf_obj]
  letI := h_mod_pi₃
  have h : Module R ↑(∏ᶜ Z₃) := e₃.toAddEquiv.module R
  convert h
```

This rewrites the `next n` to `n + 1` at the type level *before* the dsimp,
making the subsequent `convert h` succeed exactly as in the X₁/X₂ pattern.

### L1088 — `simp only [Pi.smul_apply, Finset.sum_apply, Finset.smul_sum]` made no progress

After the 5-layer functor-stack unfold at L1080, the goal is *componentwise*
(post-`funext j`) and the `Pi.smul_apply / Finset.sum_apply / Finset.smul_sum`
lemmas don't fire (the indexed-sum shape isn't exposed by the 5-layer simp set,
contrary to iter-075's hopeful framing).

**Initial repair (kept):** wrap in `try` so the chain doesn't fail.

**Follow-on cascade (L1095).** Once `try simp only [...]` is benign, the next
tactic `refine Finset.sum_congr rfl fun k _ => ?_` fails because the goal is
`_ j = _ j` (a componentwise equality), not `∑ = ∑`.  The entire iter-075
chain (funext + simp + refine + rw + congr + sorry) only works if the 5-layer
unfold actually exposes alternating-sum form, which it doesn't.

**Final repair.** Roll back h_diff_pi_smul_f body to `intro r y; sorry`,
preserving the iter-073 / iter-075 / iter-076 recipe comments (S1–S8 + sign-peel
+ sign-free 5-step) for the next iteration.

### L1170–1171 — `h_diff_pi_smul_g` application type mismatch

The statement uses `e₃ (⇑(ConcreteCategory.hom scK₀.g) (e₂.symm (r • y)))`,
but `(ConcreteCategory.hom scK₀.g) (...) : ↑scK₀.X₃` and `e₃` expects
`↑(∏ᶜ Z₃)`.  These are *not* defeq (same `next n ≠ n + 1` opaqueness as
L952).  Unlike `h_diff_pi_smul_f` (where `↑scK₀.X₂` *is* defeq to `↑(∏ᶜ Z₂)`
because `n` is literal in both), the g-variant cannot type-check without an
explicit `CochainComplex.next` rewrite — which would require the rewrite to
be inside the statement type, not the proof body.

**Repair.** Drop the `h_diff_pi_smul_g` declaration entirely.  It was only
used by `g_R.map_smul'`, which is rolled back to `sorry` in the same edit.
The intent + reduction recipe survives in the (commented) `h_diff_pi_smul_f`
block above, and the rollback note at the call site documents what the
next-iteration prover needs to re-establish.

### L1182 — isDefEq heartbeat ≥ 200000

Cascade from the L1170–1171 elaboration failure; resolved by dropping the
declaration.

### L412 — whnf heartbeat

Cascade from the L1170–1182 / L1205+ chain inside
`basicOpenCover_isCechAcyclicCover_toModuleKSheaf`.  Resolved automatically
once the inner declarations are rolled back.

### L1205 — unsolved `(ConcreteCategory.hom scK₀.f)(r • x) = (ConcreteCategory.hom scK₀.f)(e₁.symm (r • e₁ x))`

`congr 1` in the f_R calc chain expected `r • x` and `e₁.symm (r • e₁ x)` to
be definitionally equal — but the `Module R scK₀.X₁` instance found via
`h_mod_X₁` (which was built with `convert h`) is *not* the literal term
`e₁.toAddEquiv.module R`; `convert` introduces a residual congruence that
breaks the literal-equality `rfl`.

### L1213 — isDefEq heartbeat in f_R calc final step

Cascade from the failed `congr 1` above.  The calc chain `r • F(x) =
e₂.symm (r • e₂ F(x))` then tries an `Eq.refl` via the same instance-equality
issue, hitting heartbeats during the implicit unification.

**Repair (L1205+L1213+the g-variant L1214+).** Roll back `f_R.map_smul'` and
`g_R.map_smul'` to `intro r x; sorry`.  The structural-transport intent is
preserved in the rollback comments; the next iteration's prover must
re-build `h_mod_X_i` to produce a *literal* `e_i.toAddEquiv.module R`
instance (e.g., via explicit `Eq.mpr` casting on a manual `↑scK₀.X_i =
↑(∏ᶜ Z_i)` equality) so that the `r • x = e_i.symm (r • e_i x)` step
closes by `rfl`.

## Diagnostics after repair

```
{"success":true, "items": [warnings only — no errors]}
```

The warnings are:
- `declaration uses sorry` at lines 453, 819, 847, 1077, 1106, 1116, 1145
  (expected — 7 active sorries, all carrying explicit ITER-076 rollback
  comments + reduction-recipe documentation for the next iteration).
- A few `simp [π]` "flexible tactic" linter warnings at lines 796–803
  (pre-existing).
- A handful of `linter.style.longLine` warnings at lines 984–1065
  (pre-existing comments).
- One `linter.style.show` warning at L960 (my `show K₀.X ((ComplexShape.up
  ℕ).next n) = K₀.X (n + 1)` is changing the goal — but the rewrite that
  follows REQUIRES the explicit form, so I'm keeping it).

## Blueprint markers

No blueprint editing this iteration (per task scope: prover writes results, not
blueprint).  The blueprint file
`blueprint/src/chapters/Cohomology_MayerVietoris.tex § Čech acyclicity ...`
already covers this content; the deterministic `sync_leanok` phase between
prover and review will adjust `\leanok` based on the new sorry counts.

## Repair budget

- Starts: 6 sorries.
- Plan budget: at most 9.
- Ends: 7 sorries (+1 over baseline; -2 from the original budget allowance).

## Next-iteration prover handoff

The hard blocker for the four rolled-back proof bodies (`h_diff_pi_smul_f`,
`f_R.map_smul'`, `g_R.map_smul'`, `h_loc_exact`) is **instance literality**:
the `convert h` (and `convert h using N`) constructions of `h_mod_X_i` produce
instances that differ from the canonical `e_i.toAddEquiv.module R` by a
residual eta-congruence (in X₃'s case, by an opaque `CochainComplex.next`
unfold).  The next iteration's prover should:

1. Rebuild `h_mod_X_i` via explicit `Eq.mpr` over a manual `↑scK₀.X_i =
   ↑(∏ᶜ Z_i)` equality, so `(Module R scK₀.X_i).toSMul` equals
   `e_i.toEquiv.smul R` *literally*.
2. With that in hand, the iter-072 `calc` chains in `f_R.map_smul'` /
   `g_R.map_smul'` work as written (the `congr 1` for `r • x = e_i.symm
   (r • e_i x)` will close by `rfl` because the smul comes from
   `e_i.toEquiv.smul R`).
3. Then `h_diff_pi_smul_f` can be re-attacked via the documented S1–S8 recipe
   (decomposition of the 5-layer functor stack into per-summand R-linearity).
4. `h_loc_exact` is downstream of those.
