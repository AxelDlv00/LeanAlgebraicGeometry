# Iter-098 (Archon canonical) / iter-100 (project narrative) — review

## Outcome at a glance

- **Single prover lane on `BasicOpenCech.lean`** to close `cechCofaceMap_pi_smul`
  L728 per-summand `hG` discharge.
- **Result**: PARTIAL — 0 sorries closed; file compiles.
- **Structural advance**: YES — `funext j'` per-coordinate pivot
  landed; iter-101 starts from a qualitatively easier per-coordinate
  goal with a documented 6-step closure recipe.
- **Sorry trajectory**: 6/6 in BasicOpenCech.lean (hard cap, no
  regression). Target of 5 missed.
- **Line shift**: L728→L768 (+40 lines of iter-100 diagnostic comments
  and iter-101 closure-recipe comments); other sorries shift by the
  same offset.
- **Compile-verified**: yes. Seventh consecutive compile-verified
  prover iteration.
- **No new axioms; no protected signatures touched.**

## What the iter-100 plan got wrong

- **`set h_sgn : k`** was the planned scalar pin. Verified at LSP
  that `set h_sgn : ℤ` substitutes; `set h_sgn : k` does NOT. The
  `(-1)^↑i` scalar elaborates through the Preadditive ZSMul instance
  on `(∏ᶜ Z₁ ⟶ ∏ᶜ (anonymous-closure))`, not the k-scalar instance.
- **Lesson for iter-101 plan**: verify with `lean_multi_attempt` at
  L728 that `set : T` substitutes BEFORE prescribing the type in
  the directive. The `set` not folding is an unambiguous diagnostic.

## What iter-100 discovered (deep)

- `ModuleCat.hom_zsmul` IS rfl-applicable in vacuum (verified via
  `lean_run_code` on `(n • f).hom x = n • f.hom x` for concrete
  `Z : ι → ModuleCat`). But it FAILS to fire on the in-context goal
  through the Pi.lift's anonymous-closure codomain
  `∏ᶜ (fun i_1 ↦ Pi.π Z₁_unfolded (i_1 ∘ δ i) ≫ (toModuleKPresheaf
  C).map ...)`. This is a discrimination-tree pattern-unification
  issue, not a missing-lemma issue. Same root cause for
  `Preadditive.zsmul_comp`, `Linear.smul_comp`, `Preadditive.nsmul_comp`.

## Pivot that landed: `funext j'`

Goal post-funext (verified iter-100 plan-pass at LSP via `lean_goal`):
```
case h.h
[heavy context]
⊢ e₂ (eqToHom_hom (smul_thing.hom (e₁.symm (r' • y')))) j' =
   (r' • e₂ (eqToHom_hom (smul_thing.hom (e₁.symm y')))) j'
```
where `smul_thing := (-1)^↑i • Pi.lift_thing`.

The per-coordinate equation isolates a single `Z₂ j'` output, where
the R-action is concretely `(presheaf.map _).hom` via
`RingHom.toModule`. This is the frame `presheafMap_restrict_collapse`
(iter-087 L425) was built for. **Iter-101 should close in 20–40
tactic lines following the 6-step recipe documented at L748–L767**
(also in `recommendations.md` § Priority 1).

## What iter-101 plan must do

1. **Schedule a single substantive prover lane on `BasicOpenCech.lean`**
   targeting **L768** (closed per-coordinate residual). Recipe at
   L748–L767 in the file + recommendations.md § Priority 1.
2. **Tactics issue against the POST-`funext j'` goal**, not the
   pre-funext goal. The pre-funext blockers (`hom_zsmul`, `zsmul_comp`,
   etc.) are confirmed dead — do not re-prescribe them.
3. **If the 6-step recipe stalls after 3–4 sub-attempts**, escalate
   to body-local helper (Priority 2 option 1 in recommendations.md)
   or refactor lane (option 2) — do NOT try a 4th raw-tactic pass.
4. **Streak warning**: L728/L768 is now the target of 3 consecutive
   prover lanes (iter-099 partial, iter-100 partial). If iter-101
   also stalls, **mandate refactor** (option 2): introduce
   `Pi.lift_thing` as a body-local `let` so the iter-098 split-slot
   lemma's `G` family matches against the binder rather than the
   literal anonymous-closure.

## What's preserved byte-for-byte

- `alternating_sum_pi_smul_aux` body L478–L494 (iter-097).
- `alternating_sum_pi_smul_aux_sum_comp` L513–L537 (iter-098/099).
- `cechCofaceMap_pi_smul` prefix L539–L727 (iter-092 through iter-099
  bridge at L700–L712).
- Iter-100 partial chain L726–L767 (intro + simp + comments + funext +
  comments) — preserved for iter-101's entry point.

## File state at iter-100 close

- Sorries: 6 in `BasicOpenCech.lean` at L768, L860, L1184, L1212,
  L1402, L1431.
- Total project sorries: 14 (unchanged from iter-099 close).
- `lake build AlgebraicJacobian.Cohomology.BasicOpenCech` succeeds
  with two pre-existing warnings (unchanged from iter-099).
- `lean_diagnostic_messages` severity=error returns `[]` on whole
  file.
- No new axioms; no protected signature touched; `archon-protected.yaml`
  unchanged.

## Blueprint markers

No manual changes this iteration. No `\mathlibok` candidates surfaced;
no `\lean{...}` macro rename flagged; no stale `\notready`. The
deterministic `sync_leanok` phase (commit `archon[098/marker-sync]`)
ran before the review.

## `attempts_raw.jsonl` freshness

FRESH (timestamps 12:49:27Z–13:18:39Z fall within the iter-098
prover stage window per `meta.json`). Fourth consecutive iteration
without pre-processor staleness.

## Tool usage (from `attempts_raw.jsonl` summary line 1)

71 total events / 2 Edits + 1 Write (task_result) / 7
`lean_multi_attempt` / 4 `lean_diagnostic_messages` / 2 `lean_goal`
/ 11 lemma searches / 3 `lean_run_code` / 3 Reads / 6 Bash / 4
TodoWrite / 1 `lean_hover_info` / 0 `lean_verify`. Wall time:
~30 minutes within the iter-098 stage window.

## Streak status

7th consecutive compile-verified prover iteration (iter-092 +
iter-093 + iter-094 + iter-095 + iter-097 + iter-099 + iter-100;
iter-096/098 were refactor lanes that compiled too). However,
**iter-100 broke the iter-097/099 streak of 1-sorry-closed-per-iter**
— this is the first prover iter since iter-095 with 0 sorries
closed. The `funext j'` pivot is a qualitative advance (per-coordinate
goal frame), so this is a "deepening" iteration rather than
"stalled". Iter-101 has one tactic-route attempt; if that stalls,
the next iter-102 should be a refactor lane (body-local `let`
for Pi.lift_thing).
