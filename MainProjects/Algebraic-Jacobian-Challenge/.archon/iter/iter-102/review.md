# Iter-102 (Archon canonical) / iter-104 (project narrative) — review

## Outcome at a glance

- **Single prover lane on `BasicOpenCech.lean`** to close
  `cechCofaceMap_summand_family_R_linear` body at L536. **Step 2
  (stretch, L929 trailing) explicitly skipped** per plan's escalation
  rule.
- **Result**: **PARTIAL — 1 sorry closed**. L536 SOLVED via a 50-line
  body-local tactic chain (now spans L536–L599 of the post-edit file).
  File compiles end-to-end.
- **Sorry trajectory**: BasicOpenCech **7 → 6**. Project total
  **15 → 14**. Hard cap 7 met; target of 6 met; stretch of 5
  (close L929 also) not attempted per escalation rule.
- **Compile-verified**: yes (`lean_diagnostic_messages` returns `[]`
  for severity=error end-to-end). **Tenth consecutive compile-verified
  prover iteration** (iter-092, 093, 094, 095, 097, 099, 100, 101, 103,
  104).
- **No new axioms; no protected signatures touched; iter-102 refactor's
  named family & R-linearity skeleton preserved byte-for-byte.**
- **STREAK STATUS**: The 5-iter substantive lane on `cechCofaceMap_pi_smul`
  hG slot (iter-099/100/101/103) is **broken this iter** by design —
  iter-102 plan-agent switched the prover lane from the L827 hG slot
  to the NEW L536 R-linearity target after the named-family refactor
  produced an HOU-free binder frame. This iter closed L536 cleanly,
  vindicating the refactor-then-prove cadence.

## Overall progress (this session detail)

- **Total active syntactic sorry sites**: **14**, distributed:
  - `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`: **6** at
    L988, L1080, L1404, L1432, L1622, L1651 (verified via direct
    `grep` on actual tactic-position sorries; iter-103 sorries L919/
    L1243/L1271/L1461/L1490 shifted by +52 due to 53-line proof body
    insertion at L536).
  - `AlgebraicJacobian/Differentials.lean`: **5** at L122, L636,
    L957, L974, L1116 (unchanged).
  - `AlgebraicJacobian/Modules/Monoidal.lean`: **1** at L173
    (Mathlib upstream gap; off-limits).
  - `AlgebraicJacobian/Jacobian.lean`: **1** at L179
    (`nonempty_jacobianWitness`; Phase C step C3).
  - `AlgebraicJacobian/Picard/Functor.lean`: **1** at L190
    (`PicardFunctor.representable`; gated on C0–C3).
- **Solved this iter**: `cechCofaceMap_summand_family_R_linear` (L536
  body).
- **Partial this iter**: none.
- **Blocked this iter**: none directly (L929/L988 was DEFERRED, not
  attempted — falls under plan's escalation rule, not a blocker).
- **Untouched (deferred)**: 5 BasicOpenCech sorries
  (L1080/L1404/L1432/L1622/L1651) + 5 Differentials + 1 Monoidal +
  1 Jacobian + 1 Picard.Functor — total 13 untouched.

## What the iter-102 plan got right

- **Refactor-then-prove cadence delivers**. The iter-102 named-family
  refactor (Changes 1 + 2) produced an HOU-free binder-level R-linearity
  target at L536. Iter-104 prover closed it on first sustained attempt
  (~25 LSP probes), proving the design hypothesis correct. The
  fall-back on Change 3 (Fin-index mismatch) was the right call —
  attempting it at iter-102 would have stalled the entire refactor lane.
- **Step 1 / Step 2 split with explicit escalation rule**. PROGRESS.md
  stated "do NOT attempt Step 2 if Step 1 takes more than ~3 attempts."
  Step 1 took ~25 probes; prover correctly skipped Step 2 instead of
  hammering L988 in its still-blocked frame. Plan-agent's pre-stated
  rule prevented the prover from re-entering the iter-099/100/101/103
  failure pattern.
- **Mathlib lemma names verified pre-dispatch**. The directive
  named `Pi.lift_π_apply`, `ConcreteCategory.comp_apply`, and
  `presheafMap_restrict_collapse` — all fired cleanly.

## What the iter-102 plan got slightly wrong

- **Underestimated the wall time**. PROGRESS.md sketched the L536
  proof as "~15-20 LOC at binder level" with a 6-line Path A recipe.
  The actual committed body is 50 lines and took ~25 LSP probes plus
  a term-level finisher workaround. The structural difficulty wasn't
  at the named-family level (refactor design vindicated) but at the
  `letI` reconstruction inside the body — a pattern iter-092 had
  already documented but the directive did not pre-state. **Lesson
  for iter-105 directive**: pre-state the `letI perI₁/perI_int/h_mod_pi_*`
  reconstruction recipe in the directive body to save the prover the
  rediscovery cost.
- **`piIsoPi_hom_ker_subtype_apply` was named in the directive but
  fires only post-`show` def-eq pivot, not via `rw`** (same iter-099/
  103 lesson). Directive should have named `piIsoPi_inv_kernel_ι_apply`
  (for the `e₁.symm` direction) instead, or noted the show-pivot
  requirement upfront.
- **Tactic-level `rw [(presheaf.map _).hom.map_mul]` fails on the W₂
  output ring** due to HMul-synth issues. The directive's Step 4 sketch
  assumed it would fire; prover had to escape to term-level
  `Eq.trans + congrArg`. **Lesson for iter-105**: when an output ring
  is reached through `RingHom.toModule`, expect HMul-synth issues and
  pre-state the term-level finisher pattern.

## What iter-104 (this iter) discovered (deep)

### `letI` reconstruction inside body is mandatory for r • y HSMul re-synthesis

The signature-level letI bindings (`perI₁`, `perI_int`, `h_mod_pi_*`)
don't survive `intro R Z₁ Z_int e₁ e_int` in a way that the goal's
`r • y` HSMul re-synthesises against the elaborated `Pi.module +
RingHom.toModule` structure. The prover spent ~5 LSP probes
diagnosing this before adding the body-local reconstruction. This
exactly mirrors the iter-092 foundation pattern at L781–L805 of
`cechCofaceMap_pi_smul` — same project, same root cause class, same
workaround.

**Plan-directive corollary for iter-105+**: when a theorem signature
uses `letI`-bound module instances in its conclusion shape, ALWAYS
pre-state the body-local reconstruction in the directive recipe.

### `piIsoPi_inv_kernel_ι_apply` is the e₁.symm direction lemma

The forward direction lemma `piIsoPi_hom_ker_subtype_apply` (used at
iter-082 and iter-097 in the `←`-direction) does NOT cover the
`e₁.symm` direction. The inverse-form `piIsoPi_inv_kernel_ι_apply`
fires through the `(piIsoPi Z).inv.hom = e.symm` definitional equality.
**Documented at L573-L578 in the file.**

### Term-level `Eq.trans + congrArg` to bypass HMul-synth

When tactic-level `rw [(presheaf.map _).hom.map_mul]` fails (HMul-synth
on W₂), the term-level chain
`((presheaf.map Pl.op).hom.map_mul _ _).trans (congrArg (· * f y_val)
(presheafMap_restrict_collapse _ _ _ r))` composes the two needed equalities
cleanly. Requires a prior `set Pl := Pi.lift ... with hPl_def` to give
the implicit-arg metas a target type. **Documented at L590–L598.**

This term-level pattern is now project-known and should be reusable
for any HMul-synth-blocked `rw [h.map_mul]` scenario.

### Fin-index mismatch remains the L988 (was L929) blocker

The iter-102 refactor explicitly deferred Change 3 (call-site rewrite)
due to the Fin-index mismatch between `Fin (n+1)` (post-`dif_pos hRel`)
and `Fin ((prev n) + 2)` (named family). This was the correct decision
— attempting it at iter-102 would have stalled. **For iter-105**: schedule
a thin wrapper `cechCofaceMap_summand_family' : Fin (n+1) → ...` (Route B
in the iter-102 refactor agent's report) OR route via `Finset.sum_equiv`
(Route A).

## What iter-105 plan must do

See `recommendations.md` for the full directive. Headline:

1. **Schedule a refactor lane** (slug `cechcoface-summand-family-prime`)
   to insert a thin wrapper `cechCofaceMap_summand_family' : Fin (n+1)
   → ...` via `Fin.cast + eqToHom`. R-linearity transfers from
   `cechCofaceMap_summand_family_R_linear` (iter-104-proved) via
   composition.
2. **Schedule a prover lane** to close L988 via `refine
   alternating_zsmul_pi_smul_aux_sum_comp Z₁ Z_int Z₂ Finset.univ
   (fun i ↦ cechCofaceMap_summand_family' s₀ n i) (eqToHom_bridge)
   (fun i ↦ (-1)^↑i) e₁ e_int e₂ ?hG r y` with the per-summand `?hG`
   discharged via the wrapper-eq + `cechCofaceMap_summand_family_R_linear`.
3. **Pre-state in the directive**: the `letI perI₁/perI_int/h_mod_pi_*`
   body-local reconstruction recipe, the term-level
   `Eq.trans + congrArg` finisher pattern, and the
   `piIsoPi_inv_kernel_ι_apply` direction lemma.
4. **NO further raw-tactic passes on the L988 in-place frame**. Five
   confirmed dead routes; structural escape via wrapper is the only
   durable path.

## File state at iter-104 close

- Sorries: **6** in `BasicOpenCech.lean` (L988, L1080, L1404, L1432,
  L1622, L1651); **14** total across the project.
- `lean_diagnostic_messages` severity=error: `[]`.
- New axioms: none.
- Protected signatures: none touched.
- Inner-git commit log: prover stage commit + this review's session
  journal + iter sidecar.

## Honesty note

Iter-104 (this iter) delivered exactly what the iter-102 plan-agent
designed for: refactor-then-prove cadence producing one durable
closure per cycle. The L988 trailing sorry remains, but iter-105 has
a clean structural path (Route B wrapper) — not another raw-tactic
attempt against the discrim-tree blocker. **The producer-consumer
loop is now demonstrably repeatable**: iter-098 split-slot → iter-099
bridge closure (first instance); iter-102 named-family → iter-104
R-linearity closure (second instance). The cadence is the project's
primary technique for Phase A HOU-blocked targets.

## Developer feedback channel

Skipped this iter — no concrete Archon-tooling observation.
