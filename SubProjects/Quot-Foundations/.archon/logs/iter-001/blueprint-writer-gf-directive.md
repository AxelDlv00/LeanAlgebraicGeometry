# Blueprint-writer directive — Picard_FlatteningStratification.tex (GF)

Edit ONLY `blueprint/src/chapters/Picard_FlatteningStratification.tex`. The second
write-domain `references/**` authorizes a child reference-retriever if needed; the
Nitsure §4 source is already in `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex`
(L1711–1772) and `references/nitsure-hilbert-quot.pdf`.

## Strategy context

Two nodes matter: `thm:generic_flatness_algebraic` (the algebraic core, currently
`\lean{AlgebraicGeometry.TODO.genericFlatnessAlgebraic}` — no Lean decl yet) and
`thm:generic_flatness` (`\lean{AlgebraicGeometry.genericFlatness}`, a sorry whose Lean
signature is FALSE as written — see #2). The finite-module special case is already proved
axiom-clean in the `GenericFreeness` namespace.

## Required changes

### 1. `thm:generic_flatness_algebraic` — Mathlib-first framing, keep §4 as residue/fallback

The blueprint currently transcribes Nitsure §4's full prime-filtration induction. Mathlib has
MORE substrate than the chapter implies. Restructure the proof sketch so the PRIMARY attempt is
a **thin wrapper** over existing Mathlib, with the full §4 induction kept only as the residue
that survives the Mathlib reduction:
- `Module.FinitePresentation.exists_free_localizedModule_powers`
  (`Mathlib/RingTheory/Localization/Free.lean`) gives: a finitely-presented module that is free
  at a localization `R_S` becomes free after inverting some `r ∈ S`.
- Over a noetherian domain `A`, the generic fibre `M ⊗_A Frac(A)` is a finite-dimensional
  `Frac(A)`-vector space, hence FREE — so the freeness hypothesis at the generic localization is
  automatic. The whole `Module.freeLocus` API (`Mathlib/RingTheory/Spectrum/Prime/FreeLocus.lean`)
  is available.
- The genuine remaining gap is reducing the **finite-type** `A`-algebra `B` case to a finite
  `A`-module case (the polynomial-ring generic-freeness core for `M` over `A[b_1,…,b_n]`). State
  precisely which part is the surviving residue and keep the §4 induction (base case, prime
  filtration → `M=B/p` → Noether normalisation → clear denominators → torsion short exact
  sequence + induction on `dim supp_K T`) as the fallback route for that residue.

State the **exact intended Lean signature** in prose (keep the `TODO.` pin):
`(A B M : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A] [CommRing B] [Algebra A B]
[Algebra.FiniteType A B] [AddCommGroup M] [Module B M] [Module.Finite B M]
[Module A M] [IsScalarTower A B M] :
  ∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)`.

### 2. `thm:generic_flatness` — fix the false Lean signature (coherence hypotheses)

The Lean decl `genericFlatness` takes `(F : X.Modules)` with NO coherence hypothesis, so it is
FALSE as stated (a non-coherent `F` need not become flat on an open). Mathlib has no single
`IsCoherent` predicate at the pin; "coherent over a locally noetherian base" is encoded as
`[F.IsQuasicoherent]` + `[F.IsFiniteType]` (these `SheafOfModules.IsQuasicoherent` /
`SheafOfModules.IsFiniteType` predicates exist in Mathlib). Update the chapter's `\lean{}` block
prose and its `% NOTE:` to specify the corrected intended signature with these two hypotheses
added on `F`. (You edit prose only — the actual `.lean` re-sign is a separate scaffold/refactor
pass next iter; your job is to make the blueprint specify the faithful target.) Keep the
geometric proof sketch (reduce to affine `Spec A ⊆ S`, apply the algebraic core on each
finite-type-`A`-algebra patch, shrink to the common basic open `D(∏ f_i)`).

## Out of scope

- Do NOT add or remove `\leanok`.
- Do NOT edit other chapters. Do NOT touch the proved `GenericFreeness` namespace nodes.

## Citation discipline

Keep `% SOURCE:` + verbatim `% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:` and the visible
`\textit{Source: Nitsure …}` lines. Read verbatim quotes from
`references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` — do not write from memory.

Report any "Strategy-modifying findings" in that section of your report.
