# Blueprint Writer Directive

## Slug
a4b-auslander

## Target chapter
`blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` (NEW)

## Lean file this chapter is the blueprint for
`AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` (NEW — does not yet exist).

Add `% archon:covers AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` at top.

## Strategy context

Route A.4.b — Auslander–Buchsbaum import. STRATEGY.md L30 names this as gated on A.4.a but **independently startable on the Mathlib side**: the algebra is independent of the geometry. ~500-700 LOC, ~4-7 iters.

The Auslander–Buchsbaum formula: for a finitely-generated module `M` of finite projective dimension over a Noetherian local ring `(R, m, k)`,
$$\mathrm{pd}_R(M) + \mathrm{depth}_R(M) = \mathrm{depth}(R).$$

It is consumed by A.4.a (the codim-1 extension proof) to translate "regular local ring + depth ≥ 2" into "factorization through codim-2 points" — the Hartshorne III.8 mechanics for a regular projective scheme.

Mathlib currently has **parts** of this:
- `Mathlib.RingTheory.Depth.*` — depth API (present, may need extensions).
- `Mathlib.RingTheory.Regular` / `Mathlib.RingTheory.Ideal.RegularSequence` — regular sequences (present).
- `Mathlib.RingTheory.Noetherian` — projective dimension via free resolutions (partially present; some restrictions).

The chapter must clearly document what is **already present** in Mathlib (cite tags) and what the project must **fill in**.

## Required content

### Definition: depth of a module over a local ring
The standard regular-sequence definition: `depth_R(M) = length` of the longest `M`-regular sequence in `m`. Equivalent formulations:
- via Ext: `depth_R(M) = inf { i : Ext^i_R(R/m, M) ≠ 0 }`.
- via Koszul: depth via Koszul cohomology.

Cite Stacks 00LE / Stacks 0AVF. Mathlib's `Module.depth` predicate; if absent, the new in-tree material.

### Definition: projective dimension of a module
The minimal length of a projective resolution. `pd_R(M) := inf { n : ∃ projective resolution 0 → P_n → ... → P_0 → M → 0 }`.

Mathlib: `CategoryTheory.ProjectiveResolution` and `homologicalDimension` should be available — verify.

### Theorem: Auslander–Buchsbaum formula
For `R` a Noetherian local ring with maximal ideal `m` and residue field `k`, and `M` a finitely-generated `R`-module of finite projective dimension:
$$\mathrm{pd}_R(M) + \mathrm{depth}_R(M) = \mathrm{depth}(R).$$

Proof sketch (Matsumura *Commutative Ring Theory* Ch 19; or Stacks 090V): induction on `pd_R(M)`. Base case `pd_R(M) = 0` means `M` is free, so `depth_R(M) = depth(R)`. Inductive step: choose a minimal free resolution `0 → K → R^n → M → 0` and apply the depth-on-exact-sequences lemma.

### Lemma: depth of a module on an exact sequence
For a short exact sequence `0 → A → B → C → 0` of finitely-generated `R`-modules:
- `depth(A) ≥ min(depth(B), depth(C) + 1)`.
- `depth(B) ≥ min(depth(A), depth(C))`.
- `depth(C) ≥ min(depth(B), depth(A) − 1)`.

Cite Stacks 00LE.

### Corollary: regular ⇒ Cohen-Macaulay
If `R` is regular Noetherian local, then `R` is Cohen-Macaulay: `depth(R) = dim(R)`. This is the consumer A.4.a needs.

### Application sketch (gating A.4.a)
Brief paragraph: on a regular surface (such as `ℙ¹ × ℙ¹`), the Auslander–Buchsbaum formula gives `depth ≥ 2`. Codim-2 closed points then have depth-≥-2 local rings, and a rational function with no codim-1 poles extends across them (Hartshorne III.7 reformulation).

### Lean signature targets

Use `\lean{...}` markers (file `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`):

- `def:depth` → `RingTheory.Module.depth` (or whatever Mathlib name surfaces — verify).
- `def:projective_dimension` → `Module.projectiveDimension` (verify Mathlib name).
- `thm:auslander_buchsbaum` → `RingTheory.auslander_buchsbaum_formula`.
- `lem:depth_short_exact_sequence` → `RingTheory.depth_of_short_exact`.
- `cor:regular_cohen_macaulay` → `RingTheory.CohenMacaulay.of_regular`.

## Required citations

`% SOURCE: [Matsumura, Commutative Ring Theory], Theorem 19.1 ...` etc.

Read source verbatim from:
- `references/stacks-algebra.tex` tag 090V (Auslander–Buchsbaum) — search for "Auslander–Buchsbaum" in the .tex file.
- Cite Matsumura *Commutative Ring Theory* Ch 19 if available — note `references/` may not have Matsumura; if so, **dispatch a child reference-retriever** to fetch a freely-available version (e.g. Matsumura's CRT or Bruns–Herzog *Cohen-Macaulay Rings*). Your write-domain authorizes `references/**`.

If the Stacks 090V quote is available verbatim, use it; if Matsumura's chapter quote is needed for proof clarity, retrieve it.

## Out of scope

- Do NOT write the Lean file.
- Do NOT add `\leanok` / `\mathlibok`.
- Do NOT touch `content.tex`.
- Do NOT speculate about Mathlib's exact `Module.depth` API shape — verify by looking at the project's existing imports if relevant, or by `WebFetch` of a Mathlib doc page.

## Verification

`\input{...}` is the plan agent's job.

## Report format

Standard. Notes for Plan Agent:
- Confirm Mathlib status of `depth` API at the current pinned commit (`b80f227` per `lean-toolchain`).
- Flag if Mathlib has Auslander–Buchsbaum at a known signature — that would shrink this chapter to a wrapper.
