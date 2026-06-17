# DAG Walker Directive

## Slug
rigidity-albanese

## Seed
thm:codim_one_extension

## Strategy context
Phases A.4 (Albanese UP via Milne 3.2 rigidity + rational-map extension) and the
rigidity-over-k̄ argument. Chapters `Albanese_CodimOneExtension.tex`,
`Albanese_Thm32RationalMapExtension.tex`, and `RigidityKbar.tex`.

## Depth / scope
Walk the cone of the seed, then ALSO make complete the cones of the two sibling
top theorems `thm:rational_map_to_av_extends` (in
`Albanese_Thm32RationalMapExtension.tex`) and `thm:rigidity_over_kbar` (in
`RigidityKbar.tex`) — use `archon dag-query ancestors --node <each>` for all
three. PRIMARY job: transcribe missing `\uses{}` and pin the one gap. Do NOT
rewrite proven statements/proofs.

### Isolated nodes to wire (their proofs/prose cite them via `\cref{}` but the
`\uses{}` edge is missing — add the edge on the consuming block):
- thm:rational_map_to_av_extends — this is the chapter's TOP theorem and is
  isolated: its own proof assembles sub-lemmas (read it and add its `\uses{}`),
  and it should be `\uses{}`'d by whatever Albanese/Jacobian theorem consumes the
  rational-map extension. Wire both directions.
- lem:mem_domain_partial_map_reshuffle — consumed inside `thm:codim_one_extension`
  / `thm:weil_divisor_obstruction` (referenced around lines 1493–1661). Add it to
  the `\uses{}` of the block whose proof actually invokes it.
- lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable and
  lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange — both are the
  (S3.sep)/(S3.pi) substeps of `lem:constants_integral_over_base_field` in
  `RigidityKbar.tex` (see line ~2215). Add them to that lemma's `\uses{}`, and
  ensure each has its own `\uses{}` to the Stacks sources it relies on. These two
  are still UNPROVED (no `\leanok`); leave their proof state alone — just wire.

### Gap node needing a `\lean{}` pin:
- lem:stage6_regular_stalk_assembly (in `Albanese_CodimOneExtension.tex`). Check
  the covered Lean file for the real declaration name and pin `\lean{<real.name>}`
  if it exists; otherwise pin `\lean{AlgebraicGeometry.TODO.stage6_regular_stalk_assembly}`.
  Also wire it into the codim-one extension cone via `\uses{}`.

## Out of scope
Remarks (`rem:`/`rmk:`) are exempt — do not wire them. Do not add `\leanok`. Do
not edit the proof bodies of the proven lemmas beyond their `\uses{}`/`\lean{}`.

## References
- `references/abelian-varieties.md` (Milne Thm 3.2 / Prop 3.10 rigidity),
  `references/stacks-varieties.md` (035U/0BUG geom-reduced ⇒ separable, tag
  04QM), `references/stacks-fields.md` (09HD/030K purely inseparable) — only
  where a block derived from these lacks a citation line; do not rewrite existing
  cited prose.
