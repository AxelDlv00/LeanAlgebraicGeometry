# Blueprint Writer Directive

## Slug
differentials-iter110

## Target chapter
blueprint/src/chapters/Differentials.tex

## Strategy context
Iter-109 (Archon canonical) completed the C1 promotion of `LineBundle`. Iter-110 (THIS iter) opens preparation for Phase B: the four prover-viable sorries in `AlgebraicJacobian/Differentials.lean` are L122 (`relativeDifferentialsPresheaf_isSheaf`), L718 (`smooth_iff_locally_free_omega`), L735 (`cotangent_at_section`), L877 (`serre_duality_genus`). Iter-111 will dispatch a prover lane on ONE of L122/L718/L735 (L877 is variance-flagged for Serre-duality, parked behind a mathlib-analogist consult firing concurrently this iter).

Blueprint-reviewer-iter110 flagged Differentials.tex as `complete: partial` because the proof sketches for the three prover-viable non-L877 sorries lack the detail a prover needs to formalize without guessing the Mathlib entry points. Specifically:

1. **`\thm:relative_kaehler_isSheaf` (L20-26, corresponds to Lean L122)**: collapses the bulk into "the localisation compatibility $\Omega_{B[1/f]/A} \cong \Omega_{B/A} \otimes_B B[1/f]$; descent from a basis to all opens is standard". The prover needs the Mathlib name of the localisation-compatibility iso and the basis-to-opens descent recipe.
2. **`\thm:smooth_iff_locally_free_omega` (L155-161, corresponds to Lean L718)**: one-sentence proof "forward = Jacobian criterion; converse = cotangent SES + Nakayama". Neither side names the load-bearing Mathlib lemma.
3. **`\cor:cotangent_at_section` (L163-169, corresponds to Lean L735)**: no proof block at all; the prose names the conclusion but provides no derivation from `\thm:smooth_iff_locally_free_omega`.

L877 (`\thm:serre_duality_genus`) is variance-flagged for the analogist consult and DOES NOT need expansion this iter. Its current one-paragraph prose is adequate as a placeholder; do not pre-decide the closure route before the analogist returns.

## Required content

Expand the proof sketches for the three non-L877 prover-viable targets so a prover has concrete Mathlib entry points + a step-by-step formalisation guide. Each expansion should be at the level of a textbook proof or a paper-style proof of the same result — enough that a competent Lean prover can mechanise without guessing.

### 1. `\thm:relative_kaehler_isSheaf` (L20-26)

Expand the proof block (currently absent — only the theorem block exists with a one-sentence "proof reduces to ..."). The proof block should describe, in mathematical (not Lean) prose:

- **Reduction to affine basis**: invoking `Presheaf.isSheaf_iff_isSheaf_comp` (the project's working API entry; mention this name in passing as the Lean shape, but the math is "the sheaf condition for a presheaf of modules is the same as the sheaf condition for the underlying presheaf of abelian groups; the abelian-group case reduces to the affine basis case via standard basis-to-opens descent").
- **Affine basis case**: on a basic open `D(f) ⊆ Spec B`, the section is the localisation `Ω_{B[1/f]/A}`, which is isomorphic to `Ω_{B/A} ⊗_B B[1/f]` (the localisation compatibility of Kähler differentials). State the Mathlib name (e.g. `KaehlerDifferential.tensorKaehlerEquiv` or sibling — confirm with `lean_leansearch`). This compatibility makes the affine-basis presheaf a sheaf on the affine basis.
- **Basis-to-opens descent**: invoking `TopCat.Presheaf.IsSheaf.isSheafUniqueGluing` (or the `isSheafFor` family) — name the Lean entry point + describe the obstruction-free descent on the affine basis of `X`.
- **Why `SheafOfModules.IsQuasicoherent` is not viable**: keep the existing remark that this route is circular (the result we are trying to prove is the prerequisite).

The expansion should be ~1 paragraph for each of the three substeps (reduction; affine-basis case; descent), with explicit Mathlib lemma names in `\texttt{...}` so the prover can search Mathlib directly.

### 2. `\thm:smooth_iff_locally_free_omega` (L155-161)

Expand the proof sketch to a multi-paragraph proof block:

- **Forward direction (Smooth → locally free Ω)**: cite the Jacobian criterion. Mathlib has `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` (verified by strategy-critic-iter110) which gives the rank of `Ω_{B/A}` as a free `B`-module when `B/A` is standard smooth of relative dimension `n`. Lift this from the affine-local statement to a locally-free `O_X`-module via the affine basis + the relative-differentials-as-Kähler identification of the presheaf body.
- **Backward direction (locally free Ω of rank n → Smooth of relative dimension n)**: Nakayama's lemma applied at each closed point + the cotangent exact sequence (the latter is `\thm:cotangent_exact_sequence` of this chapter, label `thm:cotangent_exact_sequence`). The argument: at each point, the cotangent space is locally free of rank `n`, hence the module of Kähler differentials at that local ring has the expected rank, hence by the Jacobian-criterion's converse the ring is standard smooth of rank `n`. Name the Mathlib infrastructure (`Algebra.Smooth.iff_*` family — confirm with `lean_leansearch` for the precise iff-form name).
- **Local-to-global**: explain why locally-Smooth-everywhere implies globally Smooth: the smoothness of a morphism of schemes is a local condition on the source (the standard `Smooth` definition in `Mathlib.AlgebraicGeometry.Morphisms.Smooth`).

The expansion should be ~3 paragraphs (forward + backward + local-to-global), each naming the Mathlib lemma the prover should reach for.

### 3. `\cor:cotangent_at_section` (L163-169)

Add a proof block (currently absent). The derivation from `\thm:smooth_iff_locally_free_omega` is:

- The cotangent space at a section `s : S → X` is the pullback `s^* Ω_{X/S}`.
- Pullback preserves "locally free of rank `n`" — name the Mathlib lemma (likely in `Mathlib.AlgebraicGeometry.Modules.LocallyFree` or sibling; confirm with `lean_leansearch`).
- By `\thm:smooth_iff_locally_free_omega`, `Ω_{X/S}` is locally free of rank `n` (under the smoothness hypothesis); hence so is its pullback.

The proof block should be ~1-2 paragraphs, with the Mathlib pullback-preservation lemma named.

## Out of scope

- `\thm:serre_duality_genus` (L877): variance-flagged; do NOT expand its proof block. The mathlib-analogist consult firing concurrently this iter will determine the closure route. The chapter's current placeholder paragraph is adequate.
- `\lem:cotangent_exact_structure` (the deferred-parallel-to-`instIsMonoidal_W` sorry at Lean L636): this chapter's existing prose is in good shape per blueprint-reviewer-iter110; do NOT modify.
- The Kähler-differentials-from-Mathlib remark at L36-39 is correct and should not be touched.
- All other `\lean{...}` blocks (definitions, the cotangent SES alpha/beta/composition, etc.) are correct and should not be touched.
- Do NOT add any new `\thm:` or `\def:` blocks beyond what is named above. Stay focused on the three flagged proof-sketch expansions.

## References
- Stacks Project, Tag 01UM (Kähler differentials of localisation), Tag 02HQ (Jacobian criterion), Tag 02HW (smooth iff locally free Ω). Available online; cite by Stacks tag inline.
- Hartshorne, Algebraic Geometry, II.8 (Differentials), specifically Proposition 8.7 (smoothness criterion) and Corollary 8.10 (pullback of locally free).
- Mathlib b80f227:
  - `Mathlib.RingTheory.Smooth.StandardSmoothCotangent` — `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`.
  - `Mathlib.AlgebraicGeometry.Morphisms.Smooth` — the project's `Smooth f` predicate.
  - `Mathlib.RingTheory.Kaehler.*` — the localisation-compatibility iso (confirm name with `lean_leansearch`).
  - `Mathlib.AlgebraicGeometry.Modules.*` — pullback preservation of locally-free-of-rank (confirm name).

Spawn `reference-retriever` ONLY if the above sources are insufficient to ground a specific proof step you find you need to expand (do not pre-emptively retrieve — retrieve on demand).

## Expected outcome

A focused 3-proof-block expansion. Chapter goes from `complete: partial` to `complete: true` per blueprint-reviewer-iter110 must-fix. The chapter becomes Phase-B-prover-ready for iter-111 dispatch on L122 / L718 / L735.

## Authorisations

You may spawn child `reference-retriever` if a specific Stacks/Hartshorne section is needed and not yet cited in `references/`. Use sparingly.
