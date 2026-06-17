# DAG Walker Report

## Slug
rigidity-albanese

## Seed
thm:codim_one_extension (plus sibling tops thm:rational_map_to_av_extends,
thm:rigidity_over_kbar)

## Status
PARTIAL — the two safe, honest wirings landed; two directive items were found
already-complete (no action), and one directive item (wiring the S3 substeps into
`lem:constants_integral_over_base_field`) is DECLINED on correctness grounds and
recorded below as a strategy item. No proven statements/proofs were rewritten.

## Cone before → after
- ∞ holes (project-wide `dag-query gaps`): 0 → 0 (none in any of the three cones).
- broken \uses: 0 → 0 (no broken edges introduced; both added labels resolve).
- isolated nodes targeted: 4 named in directive →
  - `lem:mem_domain_partial_map_reshuffle`: isolated → **wired** (rdeps 0→1).
  - `lem:stage6_regular_stalk_assembly`: already non-isolated; **\lean pinned**
    (lean None→`AlgebraicGeometry.TODO.stage6_regular_stalk_assembly`).
  - `lem:S3_sep_2_…` and `lem:S3_pi_2_…`: still isolated — see "Could not complete".
- blocks added: 0; \uses edges added: 1; \lean pins added: 1.

## Blocks added / proofs written
- None. (Every node in scope already had a statement + finite-effort proof or a
  Mathlib/TODO anchor. No ∞ holes existed to fill.)

## \uses / \lean edges added/fixed (the completeness fixes)
- `thm:weil_divisor_obstruction` now `\uses{lem:mem_domain_partial_map_reshuffle}`
  (`Albanese_CodimOneExtension.tex`). Its proof establishes the equivalence
  (1) `η_W ∈ Dom(f)` ⇔ (2) `ord_W(φ_U^*(g)) ≥ 0`; the (1)-side rests on the
  membership-via-partial-map characterisation "`η_W ∈ Dom(f)` iff some
  representative `(U,φ_U)` is defined at `η_W`", which is exactly the reshuffle
  lemma. The reshuffle is also the honest Lean fallback this theorem's `\lean{}`
  was detached to in iter-179 (its NOTE block). Edge de-isolates the reshuffle
  (rdeps 0→1). Honest at the proof level.
- `lem:stage6_regular_stalk_assembly` pinned
  `\lean{AlgebraicGeometry.TODO.stage6_regular_stalk_assembly}`
  (`Albanese_CodimOneExtension.tex`). The covered Lean file
  (`AlgebraicJacobian/Albanese/CodimOneExtension.lean`) has **no** separately
  pinnable decl for the 6.C assembly: its content is the in-body closure pattern
  of `isRegularLocalRing_stalk_of_smooth`, which is already pinned by
  `lem:smooth_to_regular_local_ring` — so the assembly cannot re-pin that same
  decl. Per directive, used the `AlgebraicGeometry.TODO.*` placeholder (the
  project's established idiom for unpinnable gap nodes, cf.
  `AlgebraicGeometry.TODO.weilDivisorObstruction`,
  `AlgebraicGeometry.TODO.GrpObj_mulRight_globalises`). The node was already in
  the codim-one cone (rdeps=1 via `lem:smooth_to_regular_local_ring`), so no
  `\uses` wiring was needed — only the `\lean{}` pin.

## Already complete — no action (directive premises were stale)
- `thm:rational_map_to_av_extends` is **NOT isolated**. It already carries
  `\uses{thm:codim_one_extension, lem:milne_codim1_indeterminacy}` (its own
  proof's two inputs, Milne 3.1 + 3.3), and it is already `\uses{}`'d by **two**
  consumers — `thm:albanese_universal_property` (line 103 of
  `Albanese_AlbaneseUP.tex`) and `lem:descent_through_birational_sigma` (line 490
  of the same). Graph confirms deps=2, rdeps=2. Both directions are wired; the
  directive's "isolated, wire both directions" premise is stale. (The genuinely
  isolated label `lem:rational_map_to_av_extends` — a different, lowercase-`lem`
  placeholder reservation in `AbelianVarietyRigidity.tex` — was not in scope and
  is superseded by the real `thm:` per that chapter's STRATEGY NOTE.)

## Could not complete (genuine gaps — strategy items)
- `lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable` and
  `lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange` — **DECLINED**
  the directive's instruction to add them to
  `lem:constants_integral_over_base_field`'s `\uses{}`, on correctness grounds:
  - `lem:constants_integral_over_base_field` is **proved / `\leanok`**
    (`AlgebraicGeometry.constants_integral_over_base_field`, has_sorry=False,
    eff_loc=0, rdeps=3). The two S3 substeps are **UNPROVED** (no `\leanok`,
    eff_loc 1504 / 1880).
  - The iter-152 "alg-closed pivot" rewrote the constants proof to **path (a)**:
    under `[IsAlgClosed k]` it closes in three short steps via
    `IsAlgClosed.algebraMap_bijective_of_isIntegral`, with **no base change to
    k̄** and **no separability/inseparability factorisation**. The chapter states
    this explicitly in FOUR separate NOTE blocks (lines 2209, 2257, 2300, 2362,
    plus the proof's own NOTE at 2471): "`constants_integral_over_base_field` no
    longer uses it", retained only as descoped general-over-k Mathlib-PR fodder.
    The S3 chain is **path (b)**, which was descoped.
  - Adding the edge would therefore (i) make a *proven* node falsely depend on
    *unproven* nodes — corrupting effort/closure accounting (a done node would
    appear to have an incomplete foundation), and (ii) disagree with the actual
    Lean proof, which calls neither S3 decl. This is precisely the
    over-declaration the dag-walker's completeness condition 3 forbids.
  - The directive's secondary ask — "ensure each has its own `\uses{}` to the
    Stacks sources it relies on" — is already satisfied as far as leandag can
    express it: Stacks tags are not graph nodes, and both substeps already carry
    full `% SOURCE` / `% SOURCE QUOTE` / `\textit{Source: …}` citation blocks
    (S3.sep.2 → Tag 0BUG part (4); S3.pi.2 → Tags 09HD + 030K). No `\uses`
    blueprint edge is possible to those.
  - **Why they stay isolated:** their proofs are self-contained standalone
    field-theory facts (Artinian decomposition + alg-closed), taking
    geometric-reducedness / unique-minimal-prime as *hypotheses* — they invoke no
    other blueprint lemma (so no honest *outgoing* edge exists either), and their
    only real *consumer* was path (b) of the constants proof, now descoped.
  - **Strategy implication:** to de-isolate these honestly the project must
    either (a) author a *separate* "general-over-k constants" block that genuinely
    runs path (b) and `\uses{}` the S3 chain (kept distinct from the live
    alg-closed `lem:constants_integral_over_base_field`), or (b) formally accept
    them as orphaned general-over-k Mathlib-PR fodder (the chapter's own framing).
    A plan-agent decision, not a wiring fix.

## References consulted
- None opened for citation purposes (no new prose written). The S3 substep blocks
  already contain verbatim Stacks citations (035U/04QM, 0BUG, 02KH, 09HD/030K)
  matching `references/stacks-varieties.md` and `references/stacks-fields.md`; no
  block lacked a source line, so no reference-retriever was spawned.

## Notes for dispatcher
- The directive's "isolated / wire both directions" instruction for
  `thm:rational_map_to_av_extends` was based on a stale view — it is already fully
  wired. Suggest refreshing the directive's isolated-node list against the current
  graph before re-dispatching.
- The genuinely isolated `thm:rational_map_to_av_extends`-adjacent placeholder is
  the lowercase `lem:rational_map_to_av_extends` in `AbelianVarietyRigidity.tex`;
  per that chapter's own STRATEGY NOTE it should be retargeted/retired by a
  Plan-Agent reconciliation pass (out of this directive's scope).
- The S3-substep wiring is a real fork in the road (live alg-closed path vs.
  retained general-over-k path); see "Could not complete" for the two clean
  options. I did not touch their proof state, per directive.
- `thm:weil_divisor_obstruction` itself remains a top with rdeps=0 (a documented
  "bonus output"); its lack of a consumer is by design per `rmk:weil_obstruction_application`
  ("in the consumer chapter … `thm:weil_divisor_obstruction` is not invoked"), so
  I left it unconsumed.
