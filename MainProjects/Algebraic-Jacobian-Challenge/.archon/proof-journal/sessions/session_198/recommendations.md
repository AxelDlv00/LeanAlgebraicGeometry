# Recommendations — iter-199 plan agent

Severity-ordered. CRITICAL items must be addressed in iter-199 plan
or have a recorded rebuttal. HIGH items should be addressed unless
contradicted by a concrete reason.

## CRIT-0 — RPF placeholder bodies: chapter NOTE + no proof-block `\leanok`

**Finding**: iter-198 closed 5 `RelPicFunctor.lean` sorries with
**placeholder bodies** (constant `PUnit` functor, zero
`AddMonoidHom`, zero natural transformation, re-export). The
prover's own task report calls them placeholders; the math-correct
bodies are gated on the upstream Mathlib `Scheme.Modules`
monoidal-structure gap. `PicSharp.functorial` has `sorryAx` in its
axiom set via a typeclass leak from the sorry-bodied `addCommGroup`
instance.

**Risk**: the chapter's existing statement-block `\leanok` markers,
paired with sync_leanok adding proof-block `\leanok` to those
declarations whose `lake env lean` is clean (4 of 5), can mislead a
casual reader into thinking the relative-Picard functor is fully
implemented. The signatures match; the mathematical content does
not.

**Action for iter-199 plan agent**:
1. Add a chapter-level `% NOTE: ...` block to
   `Picard_RelPicFunctor.tex` near the `def:rel_pic_sharp` /
   `lem:rel_pic_sharp_functorial` /
   `thm:rel_pic_sharp_presheaf` /
   `def:rel_pic_etale_sheafification` /
   `thm:rel_pic_etale_sheaf_group_structure` blocks stating: the
   Lean bodies are sorry-free placeholders gated on the upstream
   Mathlib `Scheme.Modules` monoidal-structure gap. Cite the
   iter-198 review.
2. Do NOT instruct sync_leanok to add proof-block `\leanok` to any
   of these 5 declarations. (Per its deterministic semantics it
   already won't, but the plan agent should not "fix" the missing
   markers as a perceived stale-marker issue.)
3. Update `blueprint/lean_decls` (if not already done by
   sync_leanok) to register `etSheaf_group_structure` (renamed from
   `etSheafUnit`). Verify the chapter pin resolves.

**Owner**: blueprint-writer subagent (~30 LOC chapter edit) +
manual blueprint-marker maintenance by the iter-199 review agent.

**Not dispatching this iter**: same-iter fastpath blueprint-writer
dispatch deferred to iter-199 plan agent (this review agent does
NOT dispatch writers).

## CRIT-0.5 — RPF lean-vs-blueprint-checker `rpf-iter198`: ALL 6 declarations MUST-FIX-THIS-ITER

**Report**: `task_results/lean-vs-blueprint-checker-rpf-iter198.md`
(archived to `logs/iter-198/`).

The checker returned the strongest verdict possible: **all 6
declarations checked are must-fix-this-iter** (placeholder/sorry/
weakened-type bodies) + 1 major semantic-laundering risk +
1 major stale comment.

**Per-declaration findings:**
- `addCommGroup` (L269): literal `exact sorry`, upstream-gated.
- `PicSharp` (L330): constant functor at `PUnit` — **structurally
  different object**, not a type-same placeholder. The chapter
  says `T ↦ Pic(C×T)/π_T^*Pic(T)`; the Lean body is the constant
  PUnit functor.
- `functorial` (L377): zero AddMonoidHom — not the pullback-
  descended map; inherits `sorryAx` via typeclass leak.
- `presheaf` (L424): re-exports the constant-functor placeholder.
- `etSheaf` (L490): sheafification applied to the wrong (trivial)
  presheaf.
- `etSheaf_group_structure` (L539): **TYPE WEAKENED** to
  `Nonempty (...)` instead of the actual sheafification unit
  morphism with universal property. The body `⟨0⟩` is consistent
  with the weakened type but not with the math-correct signature
  the chapter prose describes.

**Imminent semantic-laundering risk**: `presheaf` and
`etSheaf_group_structure` are sorry-free (kernel-only axiom set).
If `sync_leanok` uses source-level sorry counting (which it does,
per its design), it WILL add `\leanok` to the proof blocks of
`thm:rel_pic_sharp_presheaf` and
`thm:rel_pic_etale_sheaf_group_structure` on the next iter's sync
— **semantically laundering two proof blocks that describe the
correct math but have placeholder bodies**.

**Stale Lean comment**: L505–508 in `RelPicFunctor.lean` claims
`etSheaf_group_structure` has no `\lean{...}` pin; it does (added
iter-198 via the rename `etSheafUnit` → `etSheaf_group_structure`).

**Blueprint side adequacy**: Gate annotation correctly identifies
the `Scheme.Modules` monoidal gap as the only blocker (no stale
`LineBundle.OnProduct` references). All 6 declarations are
covered with precise `\lean{...}` pins. Proof sketches are
mathematically correct. **One blueprint-side fix needed**: resolve
the type inconsistency in `thm:rel_pic_etale_sheaf_group_structure`
— the prose says "canonical morphism with universal property" but
the Lean encoding section describes `Nonempty (...)`. Either the
prose tightens to match the weakened signature, OR (better) the
signature is upgraded to the actual morphism + universal-property
hypothesis.

**Action for iter-199 plan agent** — this is the **HARD GATE**
verdict on `RelPicFunctor.lean` for iter-199:
1. **The Lean signature `etSheaf_group_structure : Nonempty (...)`
   is structurally wrong** per the blueprint's stated content.
   This is NOT a placeholder body — this is a signature mismatch.
   The plan agent should dispatch a `refactor` subagent to
   either (a) tighten the prose to match the weakened signature,
   or (b) widen the signature to a concrete morphism + universal-
   property hypothesis, then prover lane can land
   `⟨0⟩`-equivalent placeholder OR math-correct body.
2. **Add chapter NOTE on all 6 declarations** (extending CRIT-0)
   flagging the placeholder status until the upstream Mathlib
   `Scheme.Modules` monoidal-structure gap closes.
3. **Decision required**: the lean-vs-blueprint-checker's MUST-FIX
   verdict on all 6 declarations CAN be read as "the placeholder
   closure pattern is being rejected at the per-file gate level."
   If the plan agent reads it this way, **the iter-198 lane RPF
   closures should be REVERTED** (revert to `exact sorry` bodies
   + name a sorry-by-sorry plan that lands the math-correct
   bodies as the upstream gap closes). If instead the plan agent
   reads it as "placeholders are tolerable IFF disclosed in the
   chapter," then CRIT-0's chapter-NOTE mitigation is sufficient.
   This is a strategic decision; recommend EITHER:
   - **(A) Revert path**: refactor subagent to restore `exact sorry`
     bodies on `PicSharp` / `functorial` / `presheaf` / `etSheaf`
     / `etSheaf_group_structure`; reset file sorry count 1 → 6;
     plan iter-199+ around closing the upstream gap.
   - **(B) Disclose path**: chapter NOTE per CRIT-0; tighten the
     `etSheaf_group_structure` signature; keep the 5 closures.
     Source-sorry count stays at 1; chapter readers are alerted.
   Either path is consistent with USER policy directive (2)
   "strict correctness — no temporarily-wrong statements". Path
   (A) is more conservative (re-introduces honest sorries); Path
   (B) is more efficient (avoids the revert/re-land churn) but
   requires verifying the chapter NOTE actually lands and is
   visible in the rendered blueprint. **Default recommendation**:
   Path (B) with extra care on chapter NOTE wording.

## CRIT-1 — Lane Thm32 L155: do NOT re-dispatch in isolation

**Finding**: 5 prover attempts exhausted on
`isReduced_of_smooth_over_field`. The PROGRESS.md recipe ("smooth
⟹ formally smooth + geom-reduced ⟹ reduced; Mathlib gradient:
verify `Algebra.IsSmooth.isReduced` else build") **underestimates
the Mathlib gap by an order of magnitude**:
- No `Smooth → IsReduced` lemma exists in Mathlib b80f227 at any
  granularity (scheme / algebra / FormallySmooth).
- Affine-cover, stalk-level, and IsAlgClosed shortcut all fail or
  collapse circular.
- The natural derivation is via Lane COE's
  `isRegularLocalRing_stalk_of_smooth` (itself sorry at Stage 6) +
  a small `IsRegularLocalRing.isDomain` helper (~10–30 LOC, Stacks
  00NP).

**Action for iter-199 plan agent**:
- **DO NOT** assign Lane T32 L155 as an iter-199 prover lane.
- Re-classify it as a "Lane COE derivative" in PROGRESS.md and
  STRATEGY.md.
- iter-199 prover lane on T32 is **conditional on Lane COE Stage
  6 closing** (or at least sub-gap (ii.B) Krull-dim 00OE closing,
  which gives the stalk-regular ingredient).
- The 5-approach exhaustion is documented in
  `task_results/AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean.md`
  — re-dispatching cold would repeat the same exhaustion.

**Known blocker entry to add to `PROJECT_STATUS.md`**: see KB
section below.

## CRIT-2 — WeilDivisor L325 typeclass-strength gap (USER-directive-dependent)

**Finding**: `rationalMap_order_finite_support` non-zero branch is
**genuinely blocked** at the typeclass level: declaration uses
`[IsLocallyNoetherian X]`, but the proof needs `[IsNoetherian X]`
(= `[IsLocallyNoetherian X]` + `[CompactSpace X]`). A mathematical
counter-example exists (non-quasi-compact integral locally
Noetherian scheme with infinitely many disjoint codim-1 components).
The 4 routes attempted by the iter-198 prover all fail at this
level.

**Resolution path**: signature strengthening +
consumer propagation. Curve-side consumers (`principal`,
`principal_apply`, ..., `degree_positivePart_principal_eq_finrank`,
`LinearEquivalence`) recover `[CompactSpace]` for free via
`[IsProper C.hom]` over `Spec(.of kbar)`. **But the consumer files
(`OcOfD.lean`, `RRFormula.lean`, `OCofP.lean`) are Route C, PAUSED
per USER directive.**

**Action for iter-199 plan agent**:
- **DO NOT** re-dispatch Lane WD-A4a on L325 unless one of:
  - (a) USER directive amends to permit signature propagation
    through Route C consumers; OR
  - (b) L325 is split off into a separate file/module that does
    not import Route C consumers (refactoring cost ~50–100 LOC).
- Surface this as a `TO_USER.md`-eligible **decision the planner
  made on the user's behalf**: iter-198 review keeps L325 as a
  documented named blocker, awaiting USER amendment of the Route
  C scope.
- Add to `task_pending.md` as a "blocked, awaiting USER" entry.
- The 6 axiom-clean §2/§4 substrate lemmas landed this iter
  remain usable — they are not blocked, only the parent L325 is.

## CRIT-3 — Lane FGA: 5-iter zero-dispatch CHURNING — needs sorry-by-sorry closure order

**Finding (from progress-critic `route198`)**: `FGAPicRepresentability.lean`
has had **zero prover dispatches across iters 193-197**. The iter-196
carrier-soundness refactor + iter-197/198 probe verdict is
*architectural meta-work* without a sorry-closure plan. After this
iter the probe verdict can be settled, but a concrete sorry-by-sorry
closure order has not been written.

**Action for iter-199 plan agent**:
- **Decision required**: (a) commit to a sorry-by-sorry closure
  order for FGA (which sorry first, what it requires); OR (b)
  explicit USER-directed out-of-scope decision.
- The iter-198 plan-phase `blueprint-writer fga-sorry-order`
  produced a closure-order chapter (~245 LOC); read its report at
  `logs/iter-198/blueprint-writer-fga-sorry-order-report.md` to
  ground the iter-199 decision.
- Carrier-soundness probe verdict from iter-198 review: probe
  state remains NEUTRAL (no consumer breakage observed, `sorryAx`
  isolated to designed sites). The iter-198 PROBE smoke check is
  satisfied; the BROADER blast (~450–700 LOC across 5–8 iters)
  is conditional on the sorry-by-sorry plan.

## HIGH — Blueprint doctor: broken `\cref{df:Pfs}` in FGA chapter

**Finding (deterministic blueprint-doctor iter-198)**:
`blueprint/src/chapters/Picard_FGAPicRepresentability.tex` carries
a `\cref{df:Pfs}` whose label is not defined anywhere in the
included tex tree.

**Action for iter-199 plan agent**:
- Quick edit: replace `\cref{df:Pfs}` with the correct label
  (likely `def:rel_pic_sharp` in `Picard_RelPicFunctor.tex`, given
  the FGA chapter cites the iter-198 plan-phase
  `blueprint-writer fga-sorry-order` content) or remove the
  broken cite.
- One-line fix in chapter; can be done by the plan agent
  directly without dispatching a blueprint-writer.

## HIGH — WeilDivisor chapter blueprint gaps (lean-vs-blueprint-checker `wd-iter198`)

**Report**: `task_results/lean-vs-blueprint-checker-wd-iter198.md`
(archived to `logs/iter-198/`).

3 major findings + 1 minor (0 must-fix-this-iter — but all 3
majors block downstream sync_leanok / chapter-reader integrity):

1. **6 iter-198 additions unregistered**: `order_zero`,
   `order_mul_of_ne_zero`, `order_inv`, `order_units_inv` (§2) +
   `degree_neg`, `degree_sub` (§4) — all axiom-clean Lean
   declarations with no `\lean{...}` pins in
   `RiemannRoch_WeilDivisor.tex`. This explains the conservative
   `sync_leanok` delta (it skipped this chapter): no pin → no
   statement block → no marker. Once pins land, `sync_leanok`
   will auto-add `\leanok` to all six on next sync.
2. **`IsLocallyNoetherian` vs `IsNoetherian` typeclass gap absent
   from blueprint**: the iter-198 prover's 30-line structural-
   blocker comment at L326–364 of
   `rationalMap_order_finite_support` (explaining the counter-
   example to closure under `[IsLocallyNoetherian X]`) has no
   chapter counterpart. §2 still presents `[IsLocallyNoetherian
   X]` as the correct typeclass without qualification.
3. **Dangling sub-build note cross-reference**: the Lean docstring
   for `principal` references "chapter §5 sub-build note" but no
   such section exists. §5 presents Lemma 6.1 as established
   without sorry acknowledgment.
4. **Minor — stale prose**: §2 still says "Iter-173+ *may*
   introduce" `Scheme.IsRegularInCodimensionOne`; it has been
   introduced and is in use.

**Action for iter-199 plan agent**: dispatch `blueprint-writer` on
`RiemannRoch_WeilDivisor.tex` to (1) add the 6 missing
`\lean{...}` pins for §2/§4 helpers; (2) add the typeclass-gap
disclosure section (this is partly CRIT-2 territory — coordinate
with the USER-decision-dependent resolution path); (3) resolve
the dangling §5 sub-build cross-reference; (4) strip the stale
"may introduce" prose. Single ~50 LOC blueprint-writer dispatch
covers all 4 items.

## HIGH — CodimOneExtension chapter pin issues (lean-vs-blueprint-checker `coe-iter198`)

**Report**: `task_results/lean-vs-blueprint-checker-coe-iter198.md`
(archived to `logs/iter-198/`).

2 major + 2 minor (no must-fix red flags):

1. **(major) `lem:smooth_to_regular_local_ring` (blueprint L554)
   has no `\lean{...}` pin** despite having a corresponding Lean
   declaration `isRegularLocalRing_stalk_of_smooth` (private, L544)
   whose docstring cites this blueprint label. Without the pin,
   sync_leanok cannot track this gap lemma — explains why the
   "Stage 6 in-progress" status doesn't show up in sync_leanok
   counts.
2. **(major) `lem:stage6_regular_stalk_assembly` (6.C) pins to
   `isRegularLocalRing_stalk_of_smooth_aux` — a non-existent
   declaration**. The `_aux` suffix designates a planned
   extraction that was never created; the existing
   `isRegularLocalRing_stalk_of_smooth` (no `_aux`) is the
   closest match.
3. **(minor) Proof-block `\leanok` missing** on three axiom-clean
   blocks (`lem:module_free_kaehler_localization`,
   `lem:rank_kaehler_localization_eq_relative_dim`,
   `lem:mem_domain_partial_map_reshuffle`) — likely sync_leanok
   missed the two `private` declarations. (Confirming sync_leanok
   behavior on `private` decls is worth verifying for KB
   purposes.)
4. **(minor) Reversed A/B labeling**: blueprint uses 6.A = Stacks
   00OE, 6.B = Stacks 02JK; Lean docstring uses sub-gap (ii.A) =
   Stacks 02JK, sub-gap (ii.B) = Stacks 00OE. Convention drift
   that should be unified.

**Informational**: the 3 new iter-198 private helpers (L373–L459)
correctly have no blueprint pins (they are substrate helpers for
the eventual 6.B iso, not the iso itself). L820 + L888 pins resolve
correctly.

**Action for iter-199 plan agent**: dispatch `blueprint-writer` on
`Albanese_CodimOneExtension.tex` to (a) add the missing
`\lean{...}` pin on `lem:smooth_to_regular_local_ring`, (b) fix the
`lem:stage6_regular_stalk_assembly` pin to point at an existing
declaration (or convert it to a `\notready` until the `_aux`
extraction is committed), (c) unify the A/B labeling convention.
The proof-block `\leanok` minor concern is for sync_leanok itself
— possibly a project infrastructure follow-up if the `private`
issue is reproducible.

## HIGH — Lane COE: dispatch mathlib-analogist for cotangent ↔ Kähler bridge

**Finding**: iter-198 narrowed `isRegularLocalRing_stalk_of_smooth`
to two named bridges:
- (ii.A) Stacks 02JK cotangent ↔ Kähler iso over a field (~100–200
  LOC closed-point case).
- (ii.B) Stacks 00OE Krull-dim formula for standard-smooth
  (~200–300 LOC, transcendenceDegree + Noether normalisation).

**Action for iter-199 plan agent**: dispatch `mathlib-analogist`
in `## Mode: cross-domain-inspiration` for (ii.A) — the smaller of
the two gaps and the natural next slice. Search radius `narrow`
(same area). The structural problem: "lift an exact triangle of
modules over a field to a `LinearEquiv` characterizing the cotangent
space via base-change". Failed approaches: conormal sequence gives
surjectivity but not injectivity directly; codomain identification
between Mathlib `m.Cotangent` and `κ ⊗_R I` needs a bridge chain.

## HIGH — AuslanderBuchsbaum chapter NOTE + pins (lean-vs-blueprint-checker `ab-iter198` MUST-FIX-THIS-ITER)

**Report**: `task_results/lean-vs-blueprint-checker-ab-iter198.md`
(archived to `logs/iter-198/`).

The checker returned **1 must-fix-this-iter + 5 major findings**:
- **Must-fix**: `Albanese_AuslanderBuchsbaum.tex` L562–574 — the
  `% NOTE (iter-184)` comment still reads "FOUR core ingredients
  ALL absent at Mathlib b80f227". Gap (4)
  (`depth-drops-by-one`) was closed in iter-198 by
  `depth_quotSMulTop_succ_eq_depth_of_isSMulRegular`. **Must be
  corrected before iter-199 prover work on this file.**
- Major ×2: no `\lean{...}` pins for either new iter-198 helper
  (`depth_quotSMulTop_succ_eq_depth_of_isSMulRegular` and
  `exists_isSMulRegular_of_one_le_depth`).
- Major ×3: the `auslander_buchsbaum_formula_succ_pd` docstring is
  self-inconsistent (body says "all four absent"; inline comment
  L1292–1300 says "(4) closed iter-198"); the "OFF-CRITICAL-PATH"
  label at L1274 is stale; the re-engagement timeline ("piece 4 =
  iter-196 first slice") is outdated.
- **Good news**: `CohenMacaulay.of_regular` is now FULLY sorry-free
  end-to-end through `notMem_minimalPrimes_of_regularLocal_succ` —
  confirming the iter-192 chain closed completely. The only
  remaining sorry in the file is `auslander_buchsbaum_formula_succ_pd`
  (gaps 1–3).

**Action for iter-199 plan agent**: dispatch `blueprint-writer` on
`Albanese_AuslanderBuchsbaum.tex` with directive covering: (1) fix
the `% NOTE (iter-184)` "FOUR absent" → "THREE absent + ONE
closed iter-198"; (2) add `\lean{...}` pins for the two new helpers;
(3) update the `% archon:covers` block / chapter prose to reflect
the new state. ALSO direct any iter-199 prover lane that touches
the file to fix the in-file docstring inconsistencies
(`auslander_buchsbaum_formula_succ_pd` body + L1274 stale label +
L1259–1262 stale timeline) — see lean-auditor `iter198` major
finding for line specifics.

## HIGH — AuslanderBuchsbaum chapter docstring update

**Finding**: the chapter NOTE in `Albanese_AuslanderBuchsbaum.tex`
(matching the in-file docstring at L562–L574 / L1106–L1114) says
"FOUR core ingredients ALL absent at Mathlib b80f227". iter-198
closed gap (4) `depth-drops-by-one` (axiom-clean L1023–L1124) + its
companion `exists_isSMulRegular_of_one_le_depth` (L1138–L1166).

**Action for iter-199 plan agent**: dispatch `blueprint-writer` on
`Albanese_AuslanderBuchsbaum.tex` to update the "ingredients
status" enumeration: gap (4) → CLOSED iter-198; gaps (1)–(3)
remain. Add `\lean{...}` pins for the two new helpers if the
chapter discusses them at a paragraph-named level. Also
update the in-file docstring (L562–L574, L1106–L1114) — but
that's a refactor-subagent task (out of blueprint-writer scope);
plan agent should EITHER also dispatch a refactor lane OR direct
the iter-199 prover to fix the docstring in-passing.

## MEDIUM — Reusable proof-pattern catalog additions (see PROJECT_STATUS.md KB)

Three new patterns from iter-198 to add to the KB:

1. **`Ring.ordFrac` + `WithZero.log` for order/degree primitives**
   — 6 axiom-clean §2/§4 substrate lemmas in WeilDivisor via
   3–5-line proofs. Mathlib `Ring.ordFrac : K →*₀ ℤᵐ⁰` +
   `WithZero.log` discharges `order_zero`,
   `order_mul_of_ne_zero`, `order_inv`, `order_units_inv`;
   `degree_hom_apply` + `map_*` discharges `degree_neg`,
   `degree_sub`. **Reusable** for any order/degree-bundled-algebra
   on a fraction field.

2. **Depth ↔ Ext characterization via `depth_eq_smallest_ext_index`
   + LES of `Ext^*(κ, -)`** — the AB depth-drops-by-one helper. Use
   `x ∈ Ann κ` ⟹ `[x]_*` zero on `Ext^*(κ, M)` ⟹ LES short-exact
   pieces ⟹ Ext recursion. ℕ∞ equality from ℕ-indexed Ext via
   `ENat.forall_natCast_le_iff_le`. **Reusable** for any depth ↔
   Ext theorem in Noetherian local ring theory.

3. **`Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq`
   for residue-field tensor finrank** — the COE 6.B-RHS substrate.
   **Reusable** for any base-change finrank computation on Kähler
   differentials or similar free-module bundles.

## MEDIUM — Carrier-soundness probe iter-198 verdict

**Finding**: the iter-198 plan was supposed to commit a probe
verdict (per STRATEGY.md). The plan-phase agent in iter-198 noted:
*"This iter we lack a clean prover signal to act on, so the abort
verdict is deferred to the iter-198 review phase (or iter-199 plan
phase)."*

**Review-phase verdict**: probe state remains NEUTRAL — `lean_verify`
on `AlgebraicGeometry.Scheme.PicScheme` + `instHasPicScheme`
(unchanged from iter-197 close, since FGAPic was not edited this
iter) continues to show
`{propext, sorryAx, Classical.choice, Quot.sound}` (the designed
single-site `sorryAx` propagation). The RPF `functorial` `sorryAx`
leak this iter is **the same kind of typeclass leak** the
carrier-soundness probe was designed to surface — confirming the
probe's instrumentation is working. No revert action needed.
**Decision**: probe verdict CONFIRM ("structurally sound, kept as
designed"). iter-199 plan can commit this.

## LOW — sync_leanok manual review

sync_leanok iter=198 sha=`48085aee` added 2 markers, touched
`AbelianVarietyRigidity.tex` and `Picard_RelPicFunctor.tex`. The
conservative delta is consistent with the iter's substrate-helper
character. No anomalies; no manual override needed.

## Known blockers (iter-199+ plan should NOT retry without structural change)

- **`isReduced_of_smooth_over_field`** (Thm32 L155) — re-dispatch
  only AFTER Lane COE Stage 6 closes (or sub-gap (ii.B) Krull-dim
  00OE lands). 5 approaches exhausted iter-198.
- **`rationalMap_order_finite_support` non-zero branch**
  (WeilDivisor L325) — typeclass-strength gap, blocked on Route C
  consumer access. Awaiting USER directive amendment or
  refactor-split.
- **Mathlib b80f227 has no `Algebra.FormallySmooth K A →
  IsGeometricallyReduced K A`** at any layer — required for the
  smooth-over-field-reduced chain; blocks Lane T32.
- **Mathlib b80f227 has no `IsRegularLocalRing → IsDomain` bridge**
  — required for the stalk-route on Lane T32 once Lane COE closes.
  ~10–30 LOC helper (Stacks 00NP) — candidate for the iter that
  closes Lane COE.

## lean-auditor `iter198` integration

Report: `task_results/lean-auditor-iter198.md` (archived to
`logs/iter-198/lean-auditor-iter198-report.md`). Verdict aligns
with this review's CRIT-0 framing: "**between legitimate progress
and headline laundering** — closer to the laundering end for
RelPicFunctor, genuine progress in the other three files."

**Auditor's must-fix-this-iter (2, both PRE-EXISTING; carried from
iter-196/iter-197 lean-auditor)**:
- `RelPicFunctor.lean:268–269` — `-- TODO (Scheme.Modules
  monoidal-structure gate): ... exact sorry` on `addCommGroup`
  body. The gating sorry for the entire file. **Action**: per
  CRIT-0 / CRIT-3, defer until either (a) upstream Mathlib lands
  `Scheme.Modules` monoidal-structure, or (b) the project
  builds the bridge project-side. The TODO-excuse-comment
  framing is unavoidable until then; the in-file
  ``Gate annotation (iter-198 refresh)`` paragraph at L228–L235
  IS the structural disclosure the auditor's framing requires
  — review judgment is that this is acceptable, NOT must-fix
  this iter, given the actively-tracked upstream gap. Disagreement
  with auditor noted; the alternative (removing the TODO comment
  but keeping the sorry) is purely cosmetic.
- `AlbaneseUP.lean:179–183` — `bundle := sorry` with "placeholder
  carrier" docstring. Same situation: gating sorry for AlbaneseUP;
  blocked on A.3 chapter / Pic⁰ pivot landing. **Action**: defer;
  re-engage once Pic⁰ degComp pivot lands (per STRATEGY.md A.3.ii).

**Auditor's major (3, 2 new from iter-198 + 1 stale-docstring)**:
- `RelPicFunctor.lean:327–330` — `PicSharp` placeholder body.
  Already addressed by CRIT-0.
- `RelPicFunctor.lean:372–377` — `PicSharp.functorial := 0`
  sorryAx-taint. Already addressed by CRIT-0.
- `AuslanderBuchsbaum.lean:~L1241` — stale docstring "All four
  pieces are absent" (gap (4) closed iter-198). **iter-199 fix**:
  per HIGH item below; either prover lane in passing or a
  refactor dispatch (~5-LOC docstring edit).

**Auditor's minor (3)**:
- `CodimOneExtension.lean:553–554` — unused `_hflat` binding
  (scaffolding artifact). Drop in any iter-199 prover lane that
  touches the file, or in a refactor subagent dispatch (~1-LOC
  edit).
- `AuslanderBuchsbaum.lean:~L1259–1262` — re-engagement schedule
  stale ("iter-196 first slice"). Same dispatch as the L1241
  docstring fix.
- `RelPicFunctor.lean:421–544` — tautological re-export placeholders
  (`presheaf`, `etSheaf`, `etSheaf_group_structure`). Inherits
  CRIT-0 framing; covered.

## Lean-vs-blueprint-checker reports (all 4 returned during this review phase)

All 4 dispatches returned **before this review phase concluded**;
findings integrated into the relevant CRIT-* / HIGH items above
(CRIT-0.5 for RPF; HIGH for AB / WD / COE).

| Slug | Outcome | Severity peaks |
|---|---|---|
| `rpf-iter198` | 6 must-fix + 1 major + 1 stale comment | **Strongest verdict**: all 6 RPF declarations flagged; signature mismatch on `etSheaf_group_structure`; semantic-laundering risk on next sync_leanok run |
| `coe-iter198` | 2 major + 2 minor + 0 must-fix | Missing `\lean{...}` pin on `lem:smooth_to_regular_local_ring`; broken pin on `lem:stage6_regular_stalk_assembly` to non-existent `_aux` decl; A/B labeling convention drift |
| `ab-iter198` | 1 must-fix + 5 major | Chapter NOTE "FOUR core ingredients ALL absent" stale (gap 4 closed); missing pins on 2 new helpers; docstring + scheduling-timeline drift; **good news**: `CohenMacaulay.of_regular` chain fully sorry-free end-to-end |
| `wd-iter198` | 3 major + 1 minor + 0 must-fix | 6 iter-198 helpers without `\lean{...}` pins (explains conservative sync_leanok delta); typeclass-strength gap absent from blueprint; dangling §5 sub-build cross-reference |

Reports auto-archive to `logs/iter-198/` and to
`task_results/lean-vs-blueprint-checker-<slug>.md`. iter-199 plan
agent should read each report and integrate the must-fix-this-iter
findings into the plan-phase HARD GATE / dispatch decisions —
**RPF's all-6-must-fix verdict is the headline finding of this
review phase** and drives the Path A vs Path B decision under
CRIT-0.5.
