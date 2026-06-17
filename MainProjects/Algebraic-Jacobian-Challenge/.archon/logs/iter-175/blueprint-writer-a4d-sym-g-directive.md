# Blueprint Writer Directive

## Slug
a4d-sym-g

## Target chapter
blueprint/src/chapters/Albanese_AlbaneseUP.tex

## Strategy context

A.4.d is the final wiring step of the positive-genus arm: the Albanese
universal property `Hom_k(C, A) ≅ Hom_{GrpSch/k}(J, A)`, where `J := Pic⁰`
is the project's Jacobian. The chapter landed iter-174 plan-phase but the
writer's strategy-modifying finding surfaced a route conflict:

- **Route (i) — autoduality**: Milne III.6 reads `J ≅ J^∨` via the canonical
  principal polarisation, and the Albanese UP follows from the Poincaré
  bundle on `A × A^∨`. This route **gates on the theorem of the cube** —
  EXCISED iter-163. Re-introducing the cube on A.4.d would be a strategy
  reversal.
- **Route (ii) — Sym^g**: Milne Prop 6.1 verbatim — `Sym^g C ⇢ J` is a
  birational morphism, the Albanese UP follows by descent through the
  birational `σ : C^g → Sym^g C` quotient plus the rational-map-extension
  theorem (`lem:rational_map_to_av_extends` from A.4.c). Uses ONLY proven
  rigidity + A.4.c + Stein factorisation + a new project-side `Sym^g C`
  sub-build.

**Decision recorded iter-174** (`STRATEGY.md` `## Open strategic questions`):
commit to Route (ii), reject Route (i). The iter-174 chapter is "mostly
Route-(ii)-compatible" (Milne's verbatim proof is already there) BUT the
**moduli sub-lemmas (Poincaré bundle / moduli pullback)** the writer
included as auxiliaries are demoted to "alternative route history" and
need to be **retired** in favor of **Sym^g sub-lemmas**.

## Required content

This is a **refactoring-of-existing-chapter** edit. The chapter is mostly
correct; the work is replacing the moduli-theoretic sub-lemmas with
Sym^g sub-lemmas. Specifically:

1. **Remove (or move to a `% NOTE` comment block at the end)** any
   declaration block whose intent is the moduli-theoretic / autoduality
   route. Likely candidates: any block referring to "Poincaré bundle",
   "autoduality `J ≅ J^∨`", "canonical principal polarisation", "moduli
   pullback".

2. **Add three new sub-lemma blocks** for Route (ii) Sym^g — these are
   the prerequisites that `thm:albanese_universal_property` (the main
   pinned theorem of the chapter) depends on:

   - **`def:symmetric_power_curve`** — definition of `Sym^g C` as the
     quotient scheme of `C^g` by the symmetric group `S_g` action.
     Project-side new material (Mathlib has no `Sym^g` for schemes;
     only `Sym` for types and `SymmetricPower` for modules). Document
     the absence and sketch the project's intended construction (GIT
     quotient or relative-spec of the `S_g`-invariant subring at each
     affine open). `\notready` marker if the sub-build is itself
     non-trivial.

   - **`lem:symmetric_product_av_map`** — for a morphism `f : C → A`
     into an abelian variety, the map `Sym^g f : Sym^g C → A` is
     well-defined (because addition on `A` is `S_g`-symmetric). Sketch
     via `S_g`-equivariance of the addition morphism `A^g → A`.

   - **`lem:symmetric_product_to_jacobian`** — there is a birational
     morphism `Sym^g C ⇢ J` (defined off the codim-`≥ 2` locus
     `Θ ⊆ Sym^g C`). Use the project's `J` (Pic⁰) construction; the
     existence of the rational map is the cycle map `(P_1, …, P_g) ↦
     [P_1 + … + P_g - g·P_0]` for any base-point `P_0`. (Note: even
     though the *witness* J doesn't require a `k`-rational base-point
     in the project's spine, the *birational* `Sym^g C ⇢ J` is over `k̄`
     after base-change — the genus-0 arm and positive-genus arm both
     allow `k → k̄` ascent for the structural calculations; the
     `k`-uniformity is only at the level of the protected signature
     `Jacobian.isAlbaneseFor`. Document this.)

   - (Optional, if not already in the chapter)
     **`lem:descent_through_birational_sigma`** — the quotient
     `σ : C^g → Sym^g C` is birational on the dense open complement of
     the big diagonal `Δ`, so a morphism on the dense open extends to
     the whole `Sym^g C` via `lem:rational_map_to_av_extends` (A.4.c).
     If this is already pinned in A.4.c, just reference it via
     `\uses{lem:rational_map_to_av_extends}` in the main UP theorem
     block.

3. **Update `thm:albanese_universal_property`'s `\uses{}`** to reference
   the new Sym^g sub-lemmas instead of the retired moduli sub-lemmas.

4. **Update the proof body** of `thm:albanese_universal_property` to
   follow Milne Prop 6.1 verbatim using the Sym^g chain. Brief Milne
   §III.6.1 quote (from `references/abelian-varieties.pdf`, §III.6):
   "Given a morphism `f : C → A`, define `f^g : Sym^g C → A` by
   `f^g(P_1, …, P_g) := f(P_1) + … + f(P_g)`. This is well-defined as
   `Sym^g f` because `A` is commutative. The composition `Sym^g C ⇢ J
   → A` (using the rational `Sym^g C ⇢ J` plus the candidate
   `J → A`) realises `f` on points. Conversely, any
   `α : J → A` defines `f := α ∘ ι_{P_0}` for any base point `P_0 ∈ C(k̄)`.
   The two assignments are mutually inverse modulo the
   rational-map-extension."

## Out of scope

- Do NOT touch the chapter prose's general motivation paragraphs.
- Do NOT alter `\lean{...}` pins for `thm:albanese_universal_property`
  (the consumer; the proof refactor doesn't change the statement).
- Do NOT touch `\leanok` or `\mathlibok` markers.
- Do NOT change other chapters (specifically: do NOT
  edit `Albanese_Thm32RationalMapExtension.tex` — `lem:rational_map_to_av_extends`
  stays put there).
- Do NOT add fictional Mathlib API claims for Sym^g (it's absent — say
  so).

## References

- `references/abelian-varieties.pdf` (Milne) §III.6.1 — verbatim quote
  source for the Sym^g UP proof.
- `references/mumford-abelian-varieties.pdf` — alternative reference
  for `Sym^g` construction sketch (chapter on theta divisor builds
  Sym^g implicitly).
- `references/hartshorne.pdf` IV.4 — symmetric products of curves.

## Expected outcome

After your edit:
- The chapter pins `def:symmetric_power_curve`,
  `lem:symmetric_product_av_map`, `lem:symmetric_product_to_jacobian`
  (+ optionally `lem:descent_through_birational_sigma` if not in
  A.4.c) as new prerequisites for `thm:albanese_universal_property`.
- The moduli-theoretic sub-lemmas (Poincaré bundle / autoduality /
  canonical polarisation) are removed from the active dependency
  graph (either deleted or moved to an "Alternative route history"
  `% NOTE` block at the chapter's end).
- The main UP theorem's `\uses{}` and proof body cite the Sym^g
  chain, with a verbatim Milne §III.6.1 source quote.
- Strategy-modifying findings: none expected (this *executes* the
  iter-174 decision, doesn't surface new ones).
- The chapter remains HARD-GATE-clearable: complete + correct, no
  must-fix-this-iter findings.
