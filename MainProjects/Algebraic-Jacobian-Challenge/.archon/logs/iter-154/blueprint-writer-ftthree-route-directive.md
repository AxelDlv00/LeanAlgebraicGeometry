# Blueprint Writer Directive

## Slug
ftthree-route

## Target chapter
blueprint/src/chapters/RigidityKbar.tex

## Strategy context

Route C (the M2 critical path) proves genus-0 rigidity over an
algebraically closed base field `k̄` of characteristic 0. The ring-side
core lemma is
`AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
(KDM): for a domain `B` of finite type over an algebraically closed field
`k` of characteristic 0, `D_B b = 0 ⟹ b ∈ range(algebraMap k B)`. It is the
LAST open `sorry` on the chart-algebra critical path (the sibling
`constants_integral_over_base_field` was CLOSED axiom-clean at iter-153).

The KDM proof reduces to step **FT.3**: for the char-0 field extension
`K = Frac B / k`, `ker(d : K → Ω_{K/k})` = the relative algebraic closure of
`k` in `K`. Across iters 149–153 this was believed to be a research-grade
**Mathlib gap** (no shipped kernel-of-`d` lemma), and a STRATEGY.md
bright-line forbade attacking it without a `mathlib-analogist` consult.

**That consult ran this iter (iter-154) and OVERTURNED the gap verdict.**
The analogist found that every structural ingredient IS in Mathlib `b80f227`
and assembles into a complete, **compilation-verified** proof via a *cleaner
route than the old separating-transcendence-basis sketch* — the
**single-element / perfect-field / Jacobi–Zariski `H1Cotangent` route**. Your
job is to rewrite the FT section of `RigidityKbar.tex` to reflect this
verified route, so the prover (dispatched THIS iter) formalizes the right
thing.

The full verified skeleton (8 type-checking `example` blocks) and the
Mathlib citation table live in `analogies/ftthree-kernel-iter154.md` —
**read that file first**; it is the source of truth for the new route.

## Required content

This is a **project-bespoke (Archon-original) assembly** of existing Mathlib
lemmas — NOT a result transcribed from external literature. The Mathlib
lemma names below are formalization targets, tagged `[verified]` because the
analogist confirmed each composes by compilation against the project
toolchain. Do **not** invent `% SOURCE QUOTE:` blocks for the assembly steps
(they are not from a textbook); the existing Stacks/Hartshorne citations for
the *classical* "ker d = field of constants" remark may be kept as the
historical/literature pointer, but the live proof is the Mathlib assembly.

1. **Rewrite the (FT.1)–(FT.3) itemized list** (currently at
   `RigidityKbar.tex` around lines 2374–2386, inside the proof block of
   `\label{lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero}`) into
   the verified **three-step single-element route**:

   - **(FT.1) Push to the fraction field.** `B ↪ K := Frac B` (domain,
     `IsFractionRing`). The chart hypothesis `D_B b = 0` gives `D_K b = 0`
     via `KaehlerDifferential.map_D` / functoriality (the project already
     has this as the `_hFunct` reduction). `B → K` is injective, so it
     suffices to show `b ∈ K` lies in `range(algebraMap k K)`, then pull back.

   - **(FT.2) Reduce to `IsAlgebraic k b` (the perfect-field / `H1Cotangent`
     core).** Argue by contradiction: suppose `b` is transcendental over `k`.
     Then `k[X] → K`, `X ↦ b`, is injective, so `IsFractionRing.lift` embeds
     the rational function field `F := RatFunc k ≅ Frac(k[X])` into `K` as a
     subfield, with `IsScalarTower k F K`. Since `char k = 0`, `F` is a
     **perfect field** (`PerfectField.ofCharZero` [verified],
     `Mathlib.FieldTheory.Perfect`), and `K` is essentially of finite type
     over `F` (`Algebra.EssFiniteType.of_comp` from `EssFiniteType k K`
     [verified], `Mathlib.RingTheory.EssentialFiniteType`); hence
     `Algebra.FormallySmooth F K` (`FormallySmooth.of_perfectField`
     [verified], `Mathlib.RingTheory.Smooth.Field`). Formal smoothness makes
     `H¹(L_{K/F})` `Subsingleton`
     (`instSubsingletonH1CotangentOfFormallySmooth` [verified],
     `Mathlib.RingTheory.Smooth.Basic`), so by the Jacobi–Zariski exact
     sequence `H¹(L_{K/F}) →δ→ K ⊗_F Ω_{F/k} →mapBaseChange→ Ω_{K/k}`
     (`Algebra.H1Cotangent.exact_δ_mapBaseChange` [verified],
     `Mathlib.RingTheory.Kaehler.CotangentComplex`), the map
     `mapBaseChange k F K` is **injective**. Now
     `mapBaseChange k F K (1 ⊗ D_F b) = D_K b = 0`
     (`KaehlerDifferential.mapBaseChange_tmul` + `map_D` + `one_smul`
     [verified]), so `1 ⊗ D_F b = 0`, and by faithful flatness of the field
     extension `F → K` (`Module.FaithfullyFlat.one_tmul_eq_zero_iff`
     [verified], `Mathlib.RingTheory.Flat.FaithfullyFlat.Basic`), `D_F b = 0`
     where `b = algebraMap (k[X]) F X` corresponds to the indeterminate.
     This contradicts the **base case** (FT.3 below). Hence `b` is algebraic
     over `k`.

   - **(FT.3) Transcendental base case + algebraic closer.**
     - *Base case (the only genuinely-new helper, ~20 LOC, verified):*
       `D_{Frac(k[X])}(X) ≠ 0`. Proof: a localization is formally étale, so
       `Ω_{Frac k[X]/k}` is the localized module of `Ω_{k[X]/k}`
       (`KaehlerDifferential.isLocalizedModule_map` [verified],
       `Mathlib.RingTheory.Kaehler.Localization`); from `D(X) = 0` and
       `IsLocalizedModule.eq_zero_iff` [verified] there is a non-zero-divisor
       `c` with `c • D_{k[X]} X = 0`; applying the `k[X]`-linear iso
       `KaehlerDifferential.polynomialEquiv` with
       `polynomialEquiv_D : polynomialEquiv (D X) = derivative X = 1`
       [verified] (`Mathlib.RingTheory.Kaehler.Polynomial`) gives `c • 1 = 0`
       in `k[X]`, contradicting `nonZeroDivisors.coe_ne_zero`.
     - *Closer (~10 LOC, verified):* `IsAlgebraic k b ⟹ b ∈ range(algebraMap k K)`
       via `IntermediateField.adjoin.finiteDimensional` (the simple extension
       `k⟮b⟯` is finite) + `Algebra.IsIntegral.of_finite` +
       `IsAlgClosed.algebraMap_bijective_of_isIntegral` [verified,
       `Mathlib.FieldTheory.IsAlgClosed.Basic`] — the **same** lemma the
       project already uses in `constants_integral_over_base_field`.

   Use the verified `example` blocks in `analogies/ftthree-kernel-iter154.md`
   as the mathematical spine for the prose (translate them to project
   notation — do NOT paste Lean tactic syntax into the chapter).

2. **Update the `% NOTE (iter-152, residual content)` block** (around lines
   2378–2385) that currently sketches the abandoned separating-transcendence-
   basis assembly. Replace it with a one-paragraph note recording that
   (a) the iter-154 analogist verified the single-element/`H1Cotangent` route
   compiles end-to-end, (b) the transcendence-basis route is DISCARDED
   (Mathlib has no `IsTranscendenceBasis`-keyed freeness-of-`Ω` lemma and the
   single-element route makes it unnecessary), and (c) the `_mvPoly_*`
   free-case helpers (C.a)–(C.c) are now DEAD code superseded by this route.

3. **Demote the superseded (p1) char-`p` and (p2) `Differential.ContainConstants`
   blocks** (lines ~2388–2432) and the "Closure end state and ordering"
   paragraph (line ~2434): update their framing so the live route is
   unambiguously the single-element/`H1Cotangent` FT route, and the (p1)/(p2)
   blocks are clearly marked as historical/auditable records that are NOT on
   the critical path. Do NOT delete them (they are an auditable record), but
   ensure a reader sees the live route first and is not misled into thinking
   (C.a)–(C.c) helpers are still needed. This also resolves the iter-153
   lean-vs-blueprint minor that "superseded (p1)/(p2)/(BR.*) prose buries the
   ~5-line live FT route."

4. **Update the `\uses{...}` cross-references** on the KDM lemma's proof
   block if the new route introduces dependencies on different blueprint
   labels (it likely does not add new blueprint labels — the route is a
   self-contained Mathlib assembly — but verify the existing `\uses` are not
   left pointing at the now-dead (C.a)–(C.c)/(p1)/(p2) machinery as if live).

## Out of scope

- Do NOT touch any other chapter (flag cross-chapter issues in "Notes for
  Plan Agent" only).
- Do NOT touch the (S3.sep.1/2)+(S3.pi.1/2) blocks — they are descoped
  off-critical-path and are being kept verbatim as off-path scaffolds.
- Do NOT add or remove `\leanok` / `\mathlibok` markers (managed by
  sync_leanok / review).
- Do NOT change the KDM lemma's `\lean{...}` target or its signature/hypotheses
  (`[IsAlgClosed k] [CharZero k] [IsDomain B]` + finite-type + standard-smooth)
  — they are correct and the prover keeps them. (The analogist notes `n` /
  standard-smoothness are not strictly needed by the kernel argument but are
  harmless; do not remove them from the stated hypotheses.)
- Do NOT write Lean tactic syntax into the chapter prose.

## References

- `analogies/ftthree-kernel-iter154.md` — **read first**: the verified route,
  the 8 compiling `example` blocks, and the full Mathlib citation table.
- The existing `RigidityKbar.tex` FT section (lines ~2333–2435) — the block
  you are rewriting.
- `references/summary.md` — only if you keep the classical Stacks/Hartshorne
  literature pointer for the "ker d = field of constants" remark; the live
  proof is the Mathlib assembly and needs no new external source.

## Expected outcome

The KDM proof block in `RigidityKbar.tex` presents, as its live and primary
content, the three-step single-element/`H1Cotangent`/perfect-field route
(FT.1 push to `Frac B`; FT.2 perfect-field + Jacobi–Zariski injectivity
reduction to `IsAlgebraic k b`; FT.3 transcendental base case + alg-closed
closer), each step naming its `[verified]` Mathlib lemma. The transcendence-
basis sketch and the (p1)/(p2) blocks are clearly demoted to historical
records. A prover reading the chapter sees exactly the verified recipe to
formalize, with no stale "Mathlib gap / bright-line" framing remaining.
