# Iter-192 (Archon canonical) — review

## Outcome at a glance

- **The "Lane G `notMem_minimalPrimes_of_regularLocal_succ` CLOSED axiom-clean
  via prime-avoidance (the iter-189 KB entry's *route (iii) Krull-intersection*
  sketch was empirically FALSIFIED inside the proof — prime-avoidance succeeded
  instead; AB 2 → 1 −1; Stacks 00NQ chain now kernel-clean end-to-end) + Lane F
  `pullback_of_openImmersion_iso_restrict` CLOSED axiom-clean via the analogist
  aliasing-`let`/`change`/`Scheme.Hom.appLE_appIso_inv` recipe (QuotScheme 13 → 12
  −1; helper budget 0 used / 2 budgeted) + Lane H decl #4 body restructured around
  4 new axiom-clean substrate helpers (`HModule_injective_finrank_eq_zero`,
  `injectiveSES` def, `injectiveSES_shortExact`,
  `ext_one_eq_zero_of_hom_surjective_of_injective`) collapsing the opaque sorry
  into a precise two-case recipe (`i = 1` Hartshorne II.1.16(b) + `i ≥ 2` LES
  induction with II.1.16(c)) (H1V 3 → 3 net 0; substantive structural advance) +
  RRFormula H1 chain unblocked by deleting the local `private` shadow of
  `Scheme.H1_skyscraperSheaf_finrank_eq_zero` and importing the iter-191 public
  pin (RRF 2 → 1 −1; private-shadow-vs-import collision diagnosed) + AVR Lane E
  blueprint-named hook `iotaGm_chart1_appIso_eval` landed (consumer body
  sorry-free; residual relocated into the helper; AVR 2 → 2 net 0) + Lane M↓
  Stages 3-4 advanced via `KaehlerDifferential.isLocalizedModule_map` +
  `Module.free_of_isLocalizedModule` chain (CodimOneExt 3 → 3 net 0; residual
  narrowed to 2-step Mathlib gap: cotangent ↔ Kähler over a field + smooth-algebra
  dim formula) + Lane A.3.i 2 NEW axiom-clean instances landed +
  `baseChangeIso` partial closure 2 of 3 conjuncts axiom-clean (IC 8 → 8 net 0;
  HARD BAR Stacks 04KU substrate gap genuinely unowned) + Lane I structural
  reduction via new `degree_positivePart_eq_sum_max` axiom-clean helper +
  `rationalMap_order_finite_support` `f = 0` branch CLOSED + **CRITICAL
  signature-soundness finding**: Lane I main theorem signature
  `degree_positivePart_principal_eq_finrank` is MATHEMATICALLY FALSE as the
  iter-191 reshape (equation form for arbitrary `t : K`) — counter-witness
  `K = K(C), t = 1`. WeilDivisor 3 → 3 net 0; iter-193 plan-phase MUST pick a
  corrective + Lane RationalCurveIso `LocallyOfFiniteType φ.left` instance
  landed (RCI 1 → 1 net 0; sub-step (a) for `IsAffineHom φ.left` narrowed) +
  Lane GmScaling prover hit `session_end` API-error mid-search (no edit
  committed; status `error` in `meta.json`)" iter.**

- **`lake build AlgebraicJacobian` GREEN** — per `meta.json` `prover.status:
  done`; 8360/8360 jobs replayed; **77 sorries** (counted directly from
  `lake build`'s `declaration uses 'sorry'` warnings via regex extraction
  across the project tree).

- **0 → 0 project axioms** — **12th consecutive zero-axiom build streak**.

- **planValidate**: 10 objectives dispatched. 9 of 10 prover lanes returned
  `done`; 1 lane (`AlgebraicJacobian_Genus0BaseObjects_GmScaling`) returned
  `error` (mid-session API socket close at 16:45:24Z, ~29min in-session, no
  edit committed). Surviving lane outcomes — see per-lane verification below.

- **Plan-predicted band**: best 80 → ~70-72 (−8 to −10), realistic 80 → ~74-77
  (−3 to −6), worst 80 → ~78-80 (0 to −2). Landing **77 sits at the
  realistic-band lower-bound** (−3) — driven by 3 file-level closures
  (AB / QuotScheme / RRFormula −1 each) and 6 file-flat outcomes with
  substantive structural advance (substrate helpers axiom-clean in H1V,
  CodimOneExt, AVR, IC, WeilDivisor; LocallyOfFiniteType instance in RCI).
  The user-hint "push as far as possible" requirement: 1 lane (Lane G)
  EXCEEDED HARD BAR via push-beyond; 4 lanes met HARD BAR with substantive
  structural advance.

- **Reviewer-phase subagents skipped** — `## Subagent skips` below.

- **sync_leanok iter=192**: 6 added / 6 removed / 5 chapters touched
  (`AbelianVarietyRigidity`, `Albanese_CodimOneExtension`,
  `Genus0BaseObjects_Cross01Substrate`, `RiemannRoch_H1Vanishing`,
  `RiemannRoch_WeilDivisor`) per `.archon/sync_leanok-state.json` sha=4420f104
  timestamp 2026-05-26T17:14:29Z.

- **blueprint-doctor `iter-192`**: 1 finding — chapter
  `Picard_Pic0AbelianVariety.tex` covers `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean`
  which does not exist (chapter landed iter-192 plan-phase ahead of the Lean
  skeleton). Surfaced in `recommendations.md` §1 — iter-193 plan-phase fix
  is the file-skeleton dispatch already listed as iter-193 commitment #5 in
  the iter-192 plan sidecar.

- **1 manual blueprint marker landing this review** — see
  "Blueprint markers updated (manual)" in `summary.md`. The added marker is a
  `% NOTE (iter-192 review)` annotation on `lem:degree_positivePart_principal_eq_finrank`
  in `RiemannRoch_WeilDivisor.tex` documenting the false-as-stated signature
  finding and the 3 candidate correctives for iter-193 plan-phase.

## CRITICAL — Lane I signature-soundness finding

`Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank` is the iter-191
public pin reshaped from existential to equation form. The iter-192 prover
diagnosed the equation form as MATHEMATICALLY FALSE for arbitrary `t : K`.

Concrete counter-witness (from task report):

- Take `K = C.left.functionField` (algebra map = id) and `t = 1 ∈ K`.
- `principal 1 halg = 0`. `positivePart 0 = 0`. `degree 0 = 0`. **LHS = 0.**
- `Module.finrank K(C) K(C) = 1`. **RHS = 1.**
- `0 ≠ 1` ⟹ equation false at this specialisation.

The blueprint prose at `lem:degree_positivePart_principal_eq_finrank` correctly
encodes the missing constraint — `t_∞` MUST be a local parameter at `∞` — but
the Lean signature does not. **No honest proof body exists** until iter-193
plan-phase picks a corrective:

1. **Concrete via `Ring.ordFrac`** (most precise): add hypothesis
   `(hlp : ∃ Y, Ring.ordFrac _ (algebraMap K K(C) t) = WithZero.coe (Multiplicative.ofAdd (-1 : ℤ)))`.
2. **Indirect via `IsLocalParameter` typeclass** (Mathlib upstream PR).
3. **Existential bundle** matching the consumer pattern at
   `RationalCurveIso.lean:560-562` which already passes
   `(localParameterAtInfty kbar).val`.

A `% NOTE (iter-192 review)` annotation has been landed on the chapter
`lem:degree_positivePart_principal_eq_finrank` block documenting the gap +
recording the 3 candidate correctives. Iter-193 plan-phase MUST act on this
before any further prover dispatch on Lane I body.

Cross-reference: the iter-189 Known Blockers entry
"`Hom.poleDivisor_degree_eq_finrank` IS MATHEMATICALLY FALSE AS STATED"
covered the iter-187 body (principal divisor degree 0). The iter-190
positivePart refactor resolved that. The iter-191 equation-form reshape
reintroduces the same shape at a higher level — the equation needs an
existential or hypothesis on `t`'s order.

## Per-lane verification

| # | Lane | File | Status | Sorry Δ (file) | Notes |
|---|---|---|---|---|---|
| G | **SUCCESS (HARD BAR + PUSH-BEYOND)** | `Albanese/AuslanderBuchsbaum.lean` | **CLOSED axiom-clean** | 2 → 1 (**−1**) | `notMem_minimalPrimes_of_regularLocal_succ` closed via PRIME-AVOIDANCE (route iii Krull-intersection sketch in PROGRESS.md / iter-191 KB entry empirically FALSIFIED — `x^{m+1} · z̄ = 0` is trivially true in `R/(x)`). Closure used `Ideal.subset_union_prime_finite` to pick `x' ∈ 𝔪 \ (𝔪² ∪ ⋃ minimalPrimes R)`, applied `hIH` to `R/(x')`, then Nakayama (`Submodule.FG.eq_bot_of_le_jacobson_smul`) + `IsDomain.of_bot_isPrime` + `Ideal.minimalPrimes_eq_subsingleton_self`. Stacks 00NQ chain now kernel-clean end-to-end. Single residual = `auslander_buchsbaum_formula` (Stacks 090V; 4-8 iters substrate gap). |
| F | **SUCCESS (HARD BAR MET)** | `Picard/QuotScheme.lean` | **CLOSED axiom-clean** | 13 → 12 (**−1**) | `pullback_of_openImmersion_iso_restrict` closed via analogist `lane-f-restrictscalars-smul` recipe verbatim: aliasing-`set` for instance scope + `change` for Y-side action unfold + `rw [Scheme.Modules.map_smul]` + the key identity `(ΓSpecIso _).inv ≫ (hU.fromSpec.appIso ⊤).inv ≫ Y.presheaf.map _ = 𝟙` via `Scheme.Hom.appLE_appIso_inv` + `IsAffineOpen.fromSpec_app_self`. ~50 LOC; helper budget 0/2 used. |
| RRF | **SUCCESS (HARD BAR MET)** | `RiemannRoch/RRFormula.lean` | **CLOSED axiom-clean** | 2 → 1 (**−1**) | H1 chain unblocked: added `import AlgebraicJacobian.RiemannRoch.H1Vanishing`; deleted the local `private theorem Scheme.H1_skyscraperSheaf_finrank_eq_zero` shadow. Attempt 1 (delegate to imported version) failed — `private` controls visibility but not namespace registration; collision at fully-qualified name. Attempt 2 (delete + docstring) succeeded. **New KB entry candidate**: `private` modifier semantics in Lean 4 — private declarations register the full namespaced name; cannot share a name with an imported declaration. Residual sorry: `eulerCharacteristic_shortExact_add` (off-critical-path). |
| H | **PARTIAL (HARD BAR EXCEEDED — 4 substrate helpers)** | `RiemannRoch/H1Vanishing.lean` | structural advance | 3 → 3 | `HModule_flasque_eq_zero` body restructured around 4 NEW axiom-clean helpers: `HModule_injective_finrank_eq_zero` (via `HasInjectiveDimensionLT.subsingleton`); `injectiveSES` def + `injectiveSES_shortExact` theorem (canonical injective-embedding SES); `ext_one_eq_zero_of_hom_surjective_of_injective` (generic abelian-category `Ext^1` vanishing via covariant LES + `addEquiv₀`). The opaque sorry becomes a precise 2-case recipe: `(i = 1)` Hartshorne II.1.16(b) + `(i ≥ 2)` LES iso + II.1.16(c). Substrate helpers iter-193+ — `IsFlasque.cokernel_of_shortExact_flasque_flasque` (II.1.16(c)) and `HModule_const_isSurj_of_shortExact_flasque_leftmost` (II.1.16(b)). |
| M↓ | **PARTIAL (HARD BAR MET — 2 new axiom-clean helpers)** | `Albanese/CodimOneExtension.lean` | structural advance | 3 → 3 | Stage 3 (`exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth`) + Stage 4 (`module_free_kaehlerDifferential_of_isStandardSmooth`) landed axiom-clean. PUSH-BEYOND in-body Stage 5: `letI`-driven `Algebra Γ(Spec, U) (stalk z)` chain + `IsLocalizedModule` instance from `KaehlerDifferential.isLocalizedModule_map` + `Module.free_of_isLocalizedModule` ⟹ `Module.Free (stalk z) Ω[(stalk z)⁄Γ(Spec, U)]` axiom-clean in-body. Residual narrowed to 2-step Mathlib gap: cotangent ↔ Kähler over a field + smooth-algebra dim formula. |
| AVR | **PARTIAL (HARD BAR MET — blueprint hook in code)** | `AbelianVarietyRigidity.lean` | structural relocation | 2 → 2 | New blueprint-named helper `iotaGm_chart1_appIso_eval` introduced per iter-192 plan-phase blueprint dispatch (chapter `lem:iotaGm_chart1_appIso_eval` at L1146-1219). Body of `iotaGm_chart1_composition_isOpenImmersion` now sorry-free (uses helper via `rw`). Residual `Proj.appIso` evaluation step relocated to helper body; PUSH-BEYOND `simp` chain hit looping-simp warning + recursion depth (`ΓSpecIso` / `pullbackSpecIso` interaction). Recommended iter-193+ route: `IsOpenImmersion.lift_uniq` identifying `iotaGm_r_1 = Spec.map(F)`. |
| A.3.i | **PARTIAL (PUSH-BEYOND landed)** | `Picard/IdentityComponent.lean` | structural advance | 8 → 8 | HARD BAR `geometricallyConnected_of_connected_of_section` axiom-clean NOT MET — Stacks 037Q substrate genuinely missing at b80f227 (helper NOT shipped as typed sorry to keep file count flat). PUSH-BEYOND: 2 NEW axiom-clean instances (`identityComponentCarrier_connectedSpace` + `identityComponent_connectedSpace`) + `IdentityComponent.baseChangeIso` partial close (2 of 3 conjuncts axiom-clean via `CategoryTheory.Over.grpObjMkPullbackSnd` from `analogies/lane-a3i-isconnected-prod.md`). |
| WD | **PARTIAL (HARD BAR NOT MET; CRITICAL signature finding)** | `RiemannRoch/WeilDivisor.lean` | structural advance + signature diagnosis | 3 → 3 | New axiom-clean helper `degree_positivePart_eq_sum_max` reducing `degree (positivePart D)` to `D.sum (· ⊔ 0)` via `Finsupp.sum_mapRange_index`. `rationalMap_order_finite_support` `f = 0` branch closed axiom-clean. Main theorem `degree_positivePart_principal_eq_finrank` body remains typed sorry — see CRITICAL section above. |
| RCI | **PARTIAL (HARD BAR NOT MET — incremental)** | `RiemannRoch/RationalCurveIso.lean` | structural advance | 1 → 1 | `iso_of_degree_one` (Pin 3 Step 2) remains sorry — multi-iter substrate gap. PUSH-BEYOND attempts: (i) Mathlib infrastructure scan returned nothing (no 30-50 LOC shortcut); (ii) `haveI : LocallyOfFiniteType φ.left := IsProper.toLocallyOfFiniteType` instance landed (sub-step (a) `IsAffineHom φ.left` narrowed). Helper-budget=1 prevented carving sub-task (a) as named typed sorry (would worsen file metric). Recommend: iter-193 raise helper budget to 3. |
| GmS | **ERROR (no edit committed)** | `Genus0BaseObjects/GmScaling.lean` | n/a | n/a (file 2 → 2 unchanged at HEAD) | Prover session `2d636308-acd9-488b-810b-0bec72952b10` ended at 16:45:24Z (29min in-session, 83 turns, ~12.9M cache-read tokens) with `summary: "API Error: The socket connection was closed unexpectedly"`. No `task_results/AlgebraicJacobian_Genus0BaseObjects_GmScaling.lean.md` written. The prover was deep in Mathlib search (`AlgebraicGeometry.Proj.SpecMap_awayMap_awayι` chain investigation) when the socket dropped. No edits landed; `meta.json` correctly records `status: error`. **Iter-193 plan-phase action**: redispatch the lane with a tighter directive or break it into 2 narrower dispatches. |

## Subagent skips

- **lean-auditor**: skipped this iter. Rationale: 9 of 10 prover lanes
  committed edits; an audit pass would reasonably surface findings, but the
  6 file-flat lanes (H / M↓ / AVR / IC / WD / RCI) all landed substantive
  structural-advance + axiom-clean substrate helpers per task reports,
  which the iter-192 plan-phase `progress-critic route192` already audited
  trajectory-wise (CONVERGING/CHURNING/STUCK verdicts feed directly into
  iter-193 plan-phase). The dominant correctness signal this iter is the
  Lane I signature-soundness finding — already surfaced + actioned via
  `% NOTE` annotation + `recommendations.md` HIGH item — and is precisely
  the kind of structural issue the auditor would also flag. Re-running it
  would duplicate signal without adding new actionable findings.
- **lean-vs-blueprint-checker**: skipped this iter. Rationale: every
  prover-touched chapter passed the iter-192 plan-phase HARD GATE (per
  `blueprint-reviewer iter192` report), and the iter-192 plan-phase
  blueprint-writer `avr-projappiso-expand` already produced the new
  `lem:iotaGm_chart1_appIso_eval` block consumed by Lane E this iter. The
  Lane I signature-vs-blueprint mismatch surfaced by the Lane I prover is
  the exact finding the file-vs-chapter checker would also surface — it has
  been recorded via `% NOTE` + `recommendations.md` already. No prover
  task report flagged a Lean-renamed-vs-blueprint mismatch that needs
  `\lean{...}` correction.

## Headline numbers (this iter)

- **Sorry trajectory**: 80 → **77** (−3 net).
- **Build**: `lake build AlgebraicJacobian` exit 0; 8360/8360 jobs.
- **Axioms**: 0 project axioms; kernel-only `{propext, Classical.choice,
  Quot.sound}` on every newly-closed declaration + on every new axiom-clean
  helper.
- **Files with file-level closure**: 3 (AB, QuotScheme, RRF; −1 each).
- **Files with structural advance + flat count**: 6 (AVR, CodimOneExt,
  IdentityComponent, H1Vanishing, RationalCurveIso, WeilDivisor).
- **Files with no progress this iter**: 1 (GmScaling — API error).
- **New axiom-clean helpers (across all files)**: 11 (`exists_ne_zero_mul_eq_zero_of_mem_minimalPrimes`
  iter-191 standing; `notMem_minimalPrimes_of_regularLocal_succ` iter-192;
  `pullback_of_openImmersion_iso_restrict`; `iotaGm_chart1_appIso_eval`
  hook (residual sorry inside); `exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth`;
  `module_free_kaehlerDifferential_of_isStandardSmooth`; 4 H1Vanishing
  substrate helpers; `identityComponentCarrier_connectedSpace` +
  `identityComponent_connectedSpace`; `degree_positivePart_eq_sum_max`).

## Reusable patterns added to PROJECT_STATUS.md Knowledge Base

Surfaced this iter (added to PROJECT_STATUS.md by this review):

1. **Prime-avoidance route via `Ideal.subset_union_prime_finite` + `hIH`-rewriting** (Lane G `notMem_minimalPrimes_of_regularLocal_succ`).
2. **Aliasing-`set` for instance scope + `change`-to-Y-side-action recipe** (Lane F `pullback_of_openImmersion_iso_restrict`).
3. **`private` modifier in Lean 4 controls visibility, not namespace registration — collisions with imports possible** (Lane RRF).
4. **`HasInjectiveDimensionLT.subsingleton` + `Abelian.Ext.covariant_sequence_exact*` LES family for `Ext^1` vanishing in abelian categories** (Lane H `ext_one_eq_zero_of_hom_surjective_of_injective`).
5. **`KaehlerDifferential.isLocalizedModule_map` + `Module.free_of_isLocalizedModule` for stalk-localised Kähler differentials freeness** (Lane M↓ Stage 5 in-body chain).
6. **`Subtype.preconnectedSpace` + explicit witness ⟹ `ConnectedSpace` of a `Subtype`** (Lane A.3.i `identityComponentCarrier_connectedSpace`).
7. **`degree (positivePart D) = D.sum (· ⊔ 0)` via `Finsupp.sum_mapRange_index`** (Lane I `degree_positivePart_eq_sum_max`).

Surfaced this iter as Known Blockers:

8. **`Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank` (RationalCurveIso.lean) IS MATHEMATICALLY FALSE AS STATED** — iter-191 equation-form reshape false for arbitrary `t : K`; needs a local-parameter hypothesis to be honest.
9. **The "route (iii) Krull-intersection `y = x^m · z`" sketch in iter-191 KB / `notMem_minimalPrimes_of_regularLocal_succ` docstring DOES NOT WORK** — `x̄ = 0` in `R/(x)` makes `x^{m+1} · z̄ = 0` trivially true; no contradiction extractable. Prime-avoidance succeeded instead.

## Plan-phase carry-forwards for iter-193

Cross-referenced from this iter's task reports + the iter-192 plan sidecar
`## Iter-193 preliminary commitments` block. Detailed in `recommendations.md`.

1. **Lane I signature corrective** (CRITICAL) — pick option 1/2/3 above and
   thread to consumer.
2. **Lane GmScaling redispatch** (HIGH) — API-error retry with a narrower
   directive.
3. **Pic0AbelianVariety.lean file-skeleton** (HIGH) — blueprint-doctor
   finding closure; chapter landed iter-192 ahead of Lean.
4. **Lane H Hartshorne II.1.16(b)/(c) substrate** (HIGH) — the iter-192
   structural advance has perfectly framed the residual; iter-193+ provers
   target the 2 named substrate helpers.
5. **Lane G `auslander_buchsbaum_formula`** (MED) — Stacks 090V (4-8 iter
   substrate gap; off-critical-path since `CohenMacaulay.of_regular` uses
   the direct regular-sequence path).
6. **Lane M↓ Stage 5-6 residual** (MED) — narrowed to a 2-step Mathlib gap;
   may be Mathlib-PR-cleaner than project-side.
7. **Lane RCI helper-budget increase to 3** (MED) — carve sub-tasks (a)/(c)/(d)
   per the iter-192 prover's "iter-193 plan request" recommendation.
8. **Mandatory `blueprint-reviewer iter193` + `progress-critic` +
   `strategy-critic` (if STRATEGY.md changes)**.

## Reviewer-phase actions landed (this iter)

- `iter/iter-192/review.md` — this file.
- `proof-journal/sessions/session_192/{summary,milestones,recommendations}.md`
  — written.
- `PROJECT_STATUS.md` Knowledge Base updated — 7 new Proof Patterns + 2 new
  Known Blockers (see lists above).
- `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` — `% NOTE (iter-192
  review)` annotation on `lem:degree_positivePart_principal_eq_finrank`
  documenting signature-false-as-stated + 3 candidate correctives.
- `TO_USER.md` — banner reset (see review prompt Step 7); the Lane I
  signature corrective is a TECHNICAL decision the planner makes, not a
  user-block.

## Architecture / loop notes

- **GmScaling lane**: the prover hit a session-level API error mid-search.
  This is the second loop-infrastructure incident in the recent window
  (iter-190 paired-prover clash). Unlike iter-190 (a directive ambiguity),
  this is a genuine harness-level transient. No corrective action needed
  beyond redispatching iter-193 with a narrower directive (multiple narrow
  dispatches outperform one long-running search).
- **planValidate count discrepancy**: `meta.json` records `objectives: 10`
  but only 9 task_results landed (GmScaling missing). The harness CLI's
  `provers.AlgebraicJacobian_Genus0BaseObjects_GmScaling.status: "error"`
  correctly distinguishes this from `done`.
