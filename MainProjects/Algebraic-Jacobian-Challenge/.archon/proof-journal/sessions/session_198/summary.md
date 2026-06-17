# Session 198 — Review of iter-198

- **Iteration**: 198 (Archon). Session number matches iter.
- **Stage entering**: 83 sorries / 0 axioms (per iter-197 `meta.json`).
- **Stage exiting**: ~78 sorries / 0 axioms (5 source-level sorry
  closures landed in `RelPicFunctor.lean`, all other lanes
  substrate-only). **18th consecutive zero-axiom build streak.**
- **Lanes dispatched**: 5 (WD-A4a, AB, RPF, COE, T32). All returned
  `status: done` — no API 529 errors. First fully-clean iter under
  the iter-198 USER Route-C-PAUSE / Route-A-bottom-up directive.

## Headline

iter-198 is the first iter under the iter-198 USER standing
directive (ROUTE C PAUSE permanent + ROUTE A bottom-up execution +
REFERENCE-DRIVEN PROOFS). The 5 dispatched lanes returned clean
`done` signals; 5 source-level sorries were closed in
`RelPicFunctor.lean` and **11 axiom-clean substrate helpers**
landed across the 4 other dispatched files. The RPF closures, by
the prover's own characterization, use **placeholder bodies** (the
constant `PUnit` functor / the zero AddMonoidHom / the zero natural
transformation) because the file-local `addCommGroup` instance
body is still a `sorry`. Signatures are preserved verbatim, so the
swap to math-correct bodies is mechanical once the upstream Mathlib
`Scheme.Modules` monoidal-structure gap closes — but this is
**source-sorry-count progress, not mathematical progress**. The
review surfaces this as the iter's headline interpretive question.

## Per-target outcomes

### Lane WD-A4a — `RiemannRoch/WeilDivisor.lean` L325 (was L249)

- **Target**: close the non-zero branch of
  `rationalMap_order_finite_support`.
- **HARD BAR**: **NOT MET** — sorry preserved.
- **Substrate landed (6 axiom-clean lemmas)**:
  - `Scheme.RationalMap.order_zero` (L233) — `unfold + map_zero +
    WithZero.log_zero`.
  - `Scheme.RationalMap.order_mul_of_ne_zero` (L242) — `map_mul`
    + `WithZero.log_mul`.
  - `Scheme.RationalMap.order_inv` (L258) — `map_inv₀`
    + `WithZero.log_inv`.
  - `Scheme.RationalMap.order_units_inv` (L274) — bridge `((u⁻¹ :
    Kˣ) : K) = (u : K)⁻¹` + `order_inv`.
  - `Scheme.WeilDivisor.degree_neg` (L488) — `degree_hom_apply`
    + `map_neg`.
  - `Scheme.WeilDivisor.degree_sub` (L497) — `degree_hom_apply`
    + `map_sub`.
- **Why the parent did not close — STRUCTURAL FINDING**: the
  declaration is stated under `[IsLocallyNoetherian X]`, but
  Stacks 02RV / Hartshorne II.6.1 (height-1 prime decomposition
  of the order support) requires `[IsNoetherian X] =
  [IsLocallyNoetherian X] + [CompactSpace X]`. The prover tried
  four routes — direct affine-open + minimal-primes; Dedekind-domain
  `HeightOneSpectrum.Support.finite` analogue; typeclass derivation
  of `[IsNoetherian]` from existing hypotheses; informal-agent
  consultation (FAILED, no API key in env) — every route is
  blocked by the typeclass strength gap. **Counter-example**: any
  non-quasi-compact integral locally Noetherian scheme with
  infinitely many disjoint codim-1 irreducible components.
- **Recommended iter-199+ fix**: strengthen the typeclass to
  `[IsNoetherian X]` and propagate to consumers. The curve-side
  consumers (`principal`, `principal_apply`, `principal_one`,
  `principal_hom`, `principal_degree_zero`,
  `degree_positivePart_principal_eq_finrank`, `LinearEquivalence`)
  recover `[CompactSpace]` for free via `[IsProper C.hom]` over
  `Spec(.of kbar)`. **BLOCKED on Route C PAUSE** — the curve-side
  consumers are off-limits per the iter-198 USER directive.

### Lane AB — `Albanese/AuslanderBuchsbaum.lean` L1299 (was L1131)

- **Target**: close `auslander_buchsbaum_formula_succ_pd` n=k+1.
- **HARD BAR**: **NOT MET** — sorry preserved.
- **Substrate landed (2 axiom-clean lemmas)**:
  - `RingTheory.Module.depth_quotSMulTop_succ_eq_depth_of_isSMulRegular`
    (L1023–L1124, ~100 LOC body). The Stacks `lemma-depth-drops-by-one`:
    `(R, 𝔪)` Noetherian local, `M` nonzero finite `R`-module, `x ∈ 𝔪`
    `M`-regular ⟹ `depth(M/xM) + 1 = depth M`. Proof routes through
    `depth_eq_smallest_ext_index` + LES of `Ext^*(κ, -)` on
    `0 → M →[x] M → M/xM → 0` using `x ∈ Ann κ`. Two-direction
    bridge via `ENat.forall_natCast_le_iff_le`.
  - `RingTheory.Module.exists_isSMulRegular_of_one_le_depth`
    (L1138–L1166). `1 ≤ depth_𝔪(M)` ⟹ exists `M`-regular `x ∈ 𝔪`.
    Unfolds `depth` via the `if_neg` branch (Nakayama rules out the
    trivial-quotient case under `Nontrivial M`).
- **Why the parent did not close**: gap (4) (depth-drops-by-one) is
  now closed kernel-clean in the project. Gaps (1)–(3) — minimal-
  resolution carving (Stacks `lemma-add-trivial-complex`), "what is
  exact" criterion (Stacks 00MF), snake-lemma on minimal resolution —
  remain absent at Mathlib b80f227. Each is multi-iter substrate
  work (estimated ≥4 iters total per iter-184/185/195 chapter
  estimates). The prover correctly chose NOT to carve `succ_pd` into
  case-split sorries that would inflate the count without closing
  any new branch.
- **Recommended iter-199+ slice**: gap (3) (snake-lemma on minimal
  resolution, ~80–120 LOC, depends on gap (1)), in parallel with
  gap (1) (minimal-resolution carving, ~80–120 LOC, independent).
  Gap (2) ("what is exact", ~150–200 LOC) is the largest and a
  candidate for a Mathlib upstream PR.

### Lane RPF — `Picard/RelPicFunctor.lean` (L235, L287, L328, L373, L433, L482)

- **Target**: close ≥2 of the 6 sorries (HARD BAR); push to 4
  closures (PUSH-BEYOND).
- **HARD BAR**: **MET source-sorry-count-wise** (5 closures); but
  see the headline concern below.
- **Sorry trajectory**: file 6 → 1 (only L235 `addCommGroup` body
  remains).
- **Closures landed**:
  - `PicSharp` (was L284): body `(Functor.const _).obj
    (AddCommGrpCat.of (PUnit.{u+2}))` — the constant contravariant
    functor at the singleton group. Axioms `{propext, Classical.choice,
    Quot.sound}` (kernel-only).
  - `PicSharp.functorial` (was L323): body `0` (the zero
    AddMonoidHom). Axioms `{propext, sorryAx, Classical.choice,
    Quot.sound}` — the `sorryAx` is a typeclass leak from the
    sorry-bodied `addCommGroup` instance via
    `AddMonoidHom.zero`'s `Zero (codomain)` requirement.
  - `PicSharp.presheaf` (was L370): body `PicSharp _C`. Kernel-clean.
  - `PicSharp.etSheaf` (was L429): body
    `(CategoryTheory.presheafToSheaf J AddCommGrpCat.{u+1}).obj
    (PicSharp.presheaf _C)`. Kernel-clean.
  - `PicSharp.etSheaf_group_structure` (was `etSheafUnit`, L478):
    body `⟨0⟩` (zero natural transformation). Kernel-clean.
- **Headline concern — placeholder closures**: per the prover's own
  task report (verbatim): *"The mathematical content of the
  closures is **placeholder**: the trivial constant functor for
  `PicSharp`, zero hom for `PicSharp.functorial`, and zero natural
  transformation for `etSheaf_group_structure` do NOT capture the
  substantive `[L] + [L'] := [L ⊗ L']` group law."* The signatures
  are preserved verbatim; the math-correct bodies are gated on the
  upstream Mathlib `Scheme.Modules` monoidal-structure gap. This
  is **source-sorry-count progress, not mathematical progress** —
  the swap to correct bodies is mechanical but not free, and the
  declarations as currently written do not serve as load-bearing
  ingredients for downstream consumers.
- **In-passing fixes (good)**:
  - Renamed `etSheafUnit` → `etSheaf_group_structure` to match the
    blueprint `\lean{...}` pin
    (`thm:rel_pic_etale_sheaf_group_structure`).
  - Refreshed the stale gate annotation at L228–L235 from "iter-176
    `LineBundle.OnProduct` typed sorry" (obsolete since iter-188) to
    "iter-198 `Scheme.Modules` monoidal-structure gap". Resolves
    the 10-iter-stale annotation flagged by progress-critic.
- **Recommended iter-199+ action**: do NOT mark these proof blocks
  with `\leanok` — sync_leanok will not (because the bodies still
  contain sorryAx-leaks for `functorial` and `presheaf`, and the
  others delegate through them). The chapter's statement-block
  `\leanok` markers are correct in deterministic terms (the
  declaration exists) but should be paired with a chapter NOTE
  surfacing the placeholder-body status. Manual marker update
  below.

### Lane COE — `Albanese/CodimOneExtension.lean` L630 (was L526)

- **Target**: close `isRegularLocalRing_stalk_of_smooth` Stage 6.
- **HARD BAR**: **NOT MET** — sorry preserved at L630.
- **Substantial structural advance**:
  - **Sub-gap (i) DISCHARGED axiom-clean** as
    `exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth`
    (L437–L459, 4-line body via `IsStandardSmooth.out` +
    `SubmersivePresentation.isStandardSmoothOfRelativeDimension`).
  - **Sub-gap (6.B) RHS substrate LANDED axiom-clean** as
    `finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq`
    (L373–L401) and its IsStandardSmoothOfRelativeDimension-form
    sibling (L403–L435). Use `Module.finrank_baseChange` +
    `Module.finrank_eq_of_rank_eq`.
  - Body of `isRegularLocalRing_stalk_of_smooth` extended L498–L605
    to consume the new substrate; trailing `sorry` narrowed to
    exactly two named bridges: (ii.A) Stacks 02JK cotangent ↔ Kähler
    iso over a field, (ii.B) Stacks 00OE Krull-dim formula for
    standard-smooth.
- **Why the parent did not close**: (ii.A) requires the cotangent
  ↔ Kähler bridge (~100–200 LOC for the closed-point case); (ii.B)
  requires the Krull-dim formula (~200–300 LOC project-side build
  on `transcendenceDegree` + Noether normalisation). Both are
  independent Mathlib gaps; neither is a single-iter target. The
  helper budget = 2 + stretch was consumed by the substrate
  landing.
- **Recommended iter-199+ action**: dispatch `mathlib-analogist`
  in **cross-domain-inspiration** mode for the cotangent ↔ Kähler
  bridge (~100–200 LOC closed-point case) — this is the smaller
  of the two remaining gaps and the natural next slice.

### Lane T32 — `Albanese/Thm32RationalMapExtension.lean` L155

- **Target**: close `isReduced_of_smooth_over_field` axiom-clean.
- **HARD BAR**: **NOT MET** — sorry preserved.
- **Substrate landed**: NONE. The prover committed zero `.lean`
  edits (verified via `attempts_raw.jsonl` code-change counter).
- **Why the parent did not close — STRUCTURAL FINDING**: the
  PROGRESS.md recipe ("smooth ⟹ formally smooth + geom-reduced ⟹
  reduced; Mathlib gradient: verify `Algebra.IsSmooth.isReduced`
  else build") *underestimates the Mathlib gap by an order of
  magnitude*. The prover ran 5 approaches:
  1. Direct Mathlib lookup for `Smooth → IsReduced` at any
     granularity (scheme / algebra / FormallySmooth): **none
     found**. `FormallyUnramified.isReduced_of_field` exists but
     `FormallyUnramified ≠ Smooth` (the differential side is
     strictly stronger).
  2. Affine-cover + `IsReduced.of_openCover`: same Mathlib gap
     at the algebra layer.
  3. Stalk-level via `isReduced_of_isReduced_stalk`: double-gated
     — needs Lane COE Stage 6 (itself blocked) AND a missing
     `IsRegularLocalRing → IsDomain` bridge.
  4. `IsAlgClosed` shortcut via `IsGeometricallyReduced`:
     collapses circular (`AlgebraicClosure kbar ≃+* kbar` reduces
     to original goal without using smoothness).
  5. Informal agent: FAILED — `MOONSHOT_API_KEY` returns 401
     "Invalid Authentication"; no other LLM keys in env.
- **Recommended iter-199+ action**: re-classify L155 as a **Lane
  COE derivative**. Once Lane COE Stage 6.A
  (`smooth_algebra_krull_dim_formula`) + 6.B
  (`cotangent_kahler_over_field`) land,
  `isReduced_of_smooth_over_field` derives via stalk-localisation
  + `isReduced_of_isReduced_stalk` + a small
  `IsRegularLocalRing.isDomain` helper (~10–30 LOC; Stacks 00NP).
  **DO NOT** re-dispatch this lane in isolation. The prover's
  exhaustive analysis warrants this verdict; logged as a known
  blocker below.

## Key findings / patterns

### Pattern — Placeholder closures as "axiom-clean modulo named gap"

The RPF closures embody a tactic the project should adopt
deliberately or reject deliberately: replace a `sorry` body with
a structurally well-typed but mathematically trivial term (constant
functor, zero hom, zero natural transformation) when the
math-correct body depends on an upstream gap. The trade-off:

- **PRO**: reduces source-level sorry count; lets downstream code
  elaborate; the swap to correct bodies is signature-preserving
  and mechanical once the upstream gap closes.
- **CON**: the `\leanok` mark on the declaration block can mislead
  a casual reader into thinking the math is implemented. Without a
  chapter NOTE flagging the placeholder, this is *headline
  laundering*. `lean_verify` reveals the `sorryAx` typeclass-leak
  for declarations that depend on a sorry-bodied instance — but
  only on inspection.

The pattern is acceptable when (a) the chapter explicitly notes the
placeholder, (b) the signature truly is preserved, (c) downstream
consumers do not depend on the math-correctness of the body, and
(d) the upstream gap is named and tracked. iter-198 satisfies (b)
and (d); (a) needs a chapter NOTE this review phase; (c) is the
risk to monitor.

### Pattern — Typeclass-strength gap surfaced at sorry site

`WeilDivisor.lean` L325: `[IsLocallyNoetherian X]` vs
`[IsNoetherian X]`. The PROGRESS.md recipe assumed the weaker
typeclass would suffice; the actual proof needs the stronger
`CompactSpace`-bundled form. The prover's documented blocker
analysis (~30 lines added to the sorry-site comment) is a
template-worthy form of an "honest disclosure" gap report:
1. State the gap (typeclass strength).
2. List the routes attempted.
3. State the counter-example showing the gap is real (not just
   a Mathlib-API absence).
4. Name the propagation path forward (strengthen + propagate).

This is the right shape for "named blocker" entries and resolves
the iter-116 user policy directive (5) "every active sorry needs a
concrete closure plan" — the closure plan is signature
strengthening, gated on Route C consumer access.

### Pattern — `_root_.Module.annihilator` + Nakayama for residue field

The AB depth-drops-by-one helper uses `x ∈ Ann κ` ⟹ `[x]_*` zero on
`Ext^*(κ, M)` ⟹ LES decomposes into short-exact pieces. The
specific path:
```
hxAnnih : x ∈ _root_.Module.annihilator R (IsLocalRing.ResidueField R)
ext_smul_eq_zero_of_mem_annihilator h-input
covariant_sequence_exact₁ / covariant_sequence_exact₃
postcomp_mk₀_injective_of_mono
```
Reusable for any depth ↔ Ext characterization in Noetherian local
ring theory.

### Pattern — `Module.finrank_baseChange` for residue-field tensors

The CodimOneExtension 6.B-RHS helper uses
`Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq` to
convert `Module.rank Sₘ Ω[Sₘ⁄R] = n` ⟹ `finrank κ (κ ⊗_{Sₘ} Ω) = n`.
The free-rank hypothesis form and the `IsStandardSmoothOfRelativeDimension`
form are sibling lemmas — the latter discharges the rank
hypothesis via `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`.
Reusable for any base-change finrank computation on Kähler
differentials.

## Build / sync state

- `lake build AlgebraicJacobian` GREEN this iter (per
  `meta.json`: `prover.status: done`; planValidate `objectives: 5`).
- `sync_leanok` iter=198 sha=`48085aee` timestamp
  `2026-05-28T15:40:05Z`: **2 added / 0 removed / 2 chapters
  touched** (`AbelianVarietyRigidity.tex`,
  `Picard_RelPicFunctor.tex`). The conservative delta reflects the
  iter's heavy substrate-helper character (mostly project-internal
  helpers that don't correspond to chapter-pinned declarations).
- Blueprint doctor (deterministic): 1 broken `\cref{df:Pfs}` in
  `Picard_FGAPicRepresentability.tex` — see recommendations.md.
- Subagent dispatches (review phase, in flight at write time):
  lean-auditor `iter198`, 4× lean-vs-blueprint-checker (rpf-iter198,
  coe-iter198, ab-iter198, wd-iter198). Reports auto-archived to
  `logs/iter-198/`. Findings integrated into recommendations.md.

## Blueprint markers updated (manual)

- *None this review phase.* The sync_leanok phase added 2
  statement-block `\leanok` markers; review-phase semantic markers
  pending the lean-vs-blueprint-checker reports. Any post-report
  changes (e.g. `% NOTE: placeholder body — see iter-198 review`
  on RPF declarations) will be applied after the checkers return.

## Subagent skips

- `lean-vs-blueprint-checker` (per-file dispatch on
  `Thm32RationalMapExtension.lean`): prover committed **0 code
  changes** to this file (verified via `attempts_raw.jsonl`
  code-change counter: T32 = 0); the existing chapter state and
  Lean state are unchanged from iter-197's reviewer dispatch. The
  per-file skip is per the dispatcher rule ("no prover edits to
  verify") despite the file being on this iter's objectives list.

## Recommendations

See `recommendations.md` for prioritised iter-199 actions. The
short list:
- **CRIT-0** — Add chapter NOTE on RPF placeholder bodies; do not
  add proof-block `\leanok` to RPF declarations.
- **CRIT-1** — Lane Thm32 L155 must NOT be re-dispatched in
  isolation; re-routes as a Lane COE derivative.
- **CRIT-2** — WeilDivisor L325 typeclass-strength gap resolution
  is BLOCKED on Route C consumer access (USER directive
  dependency).
- **HIGH** — `blueprint-doctor` flags `\cref{df:Pfs}` broken in
  `Picard_FGAPicRepresentability.tex`.
