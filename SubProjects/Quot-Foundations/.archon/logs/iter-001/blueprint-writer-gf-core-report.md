# Blueprint Writer Report

## Slug
gf-core

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_FlatteningStratification.tex

## Changes Made

- **Revised** `thm:generic_flatness_algebraic` (statement body) — appended a prose
  paragraph stating the intended formal target: \(M\) regarded as an \(A\)-module
  through the scalar tower \(A \to B \to M\), conclusion packaged as
  \texttt{LocalizedModule (Submonoid.powers f) M} free over \texttt{Localization.Away f}.
  Added a machine-facing `% INTENDED LEAN SIGNATURE:` comment block carrying the
  exact target signature `(A B M : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A]
  [CommRing B] [Algebra A B] [Algebra.FiniteType A B] [AddCommGroup M] [Module B M]
  [Module.Finite B M] [Module A M] [IsScalarTower A B M] : ∃ f : A, f ≠ 0 ∧ Module.Free …`.
  The `\lean{AlgebraicGeometry.TODO.genericFlatnessAlgebraic}` pin is kept as directed.

- **Revised** `thm:generic_flatness_algebraic` (proof block) — restructured into a
  **Mathlib-first** sketch with three labelled parts:
  - *Primary route (finite \(A\)-module case):* a thin wrapper. Over noetherian \(A\)
    a finite \(A\)-module is finitely presented; the generic fibre
    \(M_K = K \otimes_A M = S^{-1}M\) (\(S = A\setminus\{0\}\), \(K=\mathrm{Frac}(A)\))
    is a finite-dimensional \(K\)-vector space, hence free, so the freeness hypothesis
    at the generic localisation is automatic. Conclusion is then exactly
    `Module.FinitePresentation.exists_free_localizedModule_powers`
    (`Mathlib.RingTheory.Localization.Free`); openness recorded via the
    `Module.freeLocus` API (`Mathlib.RingTheory.Spectrum.Prime.FreeLocus`).
  - *Surviving residue:* the genuine gap not in Mathlib is reducing the finite-type
    \(B\)-algebra case to the finite \(A\)-module case — the polynomial-ring
    generic-freeness core (a finite module over \(A[b_1,\dots,b_n]\) becomes free
    after inverting one \(f\in A\)). Stated precisely as the residue.
  - *Fallback (Nitsure §4 induction):* the full prime-filtration / Noether
    normalisation / clear-denominators / torsion SES + induction on
    \(\dim\mathrm{supp}_K T\) argument, kept verbatim as the route for the residue,
    with a closing sentence tying its base back to the finite \(A\)-module primary route.

- **Revised** `thm:generic_flatness` (`% NOTE:` + statement body) — rewrote the NOTE
  to specify the corrected intended signature: coherence over a locally noetherian
  base encoded as `[F.IsQuasicoherent]` + `[F.IsFiniteType]` (no single `IsCoherent`
  predicate at the pin), with the full corrected `theorem genericFlatness … (F : X.Modules)
  [F.IsQuasicoherent] [F.IsFiniteType] : …` signature recorded for the re-sign pass.
  Added a visible prose paragraph in the statement body explaining that coherence is
  essential (false without it) and is formally encoded as the conjunction of
  `SheafOfModules.IsQuasicoherent` + `SheafOfModules.IsFiniteType`. The geometric
  proof sketch (affine reduction → algebraic core per patch → common basic open
  \(D(\prod f_i)\)) is unchanged.

No `\leanok` added or removed (the pre-existing stray `\leanok` inside the
`thm:generic_flatness` environment was left untouched, per "do not add/remove").
No `\mathlibok` added (see Notes). No other chapters touched; `GenericFreeness`
namespace nodes untouched (they live in the `.lean` file, not this chapter).

## Cross-references introduced
- None new. The existing edge `thm:generic_flatness \uses{thm:generic_flatness_algebraic}`
  is preserved; `leandag build --json` reports `unknown_uses: []` and neither node is
  isolated (the 4 isolated nodes are all `lean_aux`, unrelated to this chapter).

## References consulted
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` (L1706–1787) — read
  the verbatim Lemma on Generic Flatness statement (L1711–1716), its full induction
  proof (L1719–1772), the linking sentence (L1776–1777), and the geometric Theorem
  (L1781–1787). The pre-existing `% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:` blocks
  were confirmed character-faithful against the source and left in place; no quote was
  written from memory.
- `references/summary.md` — index; confirmed Nitsure §4 is the primary source.

## Mathlib verification (read-only, to ground the prose)
Verified the named declarations exist with the stated signatures via lean LSP loogle:
- `Module.FinitePresentation.exists_free_localizedModule_powers`
  (`Mathlib.RingTheory.Localization.Free`) — confirmed: FP module free over `Rₛ` ⇒
  free over `Localization (Submonoid.powers r)` for some `r ∈ S`.
- `SheafOfModules.IsQuasicoherent`
  (`Mathlib.Algebra.Category.ModuleCat.Sheaf.Quasicoherent`) — confirmed (a `Prop`).
- `SheafOfModules.IsFiniteType`
  (`Mathlib.Algebra.Category.ModuleCat.Sheaf.Generators`) — confirmed (a `Prop`).
`Module.freeLocus` referenced from `Mathlib.RingTheory.Spectrum.Prime.FreeLocus` as
named in the directive (not separately re-verified; rate-limited, but directive named
file path explicitly).

## Macros needed (if any)
- None. Prose uses only existing macros (`\Spec`, `\OO`, `\F`, `\pp`, `\cref`) plus
  `\texttt{}` for the Lean/Mathlib identifiers.

## Reference-retriever dispatches (if any)
- None. The Nitsure §4 source was already present locally.

## Notes for Plan Agent
- **Mathlib dependency anchors not added.** The directive did not name explicit
  `\mathlibok` anchors, so I left `Module.FinitePresentation.exists_free_localizedModule_powers`,
  `Module.freeLocus`, `SheafOfModules.IsQuasicoherent`, `SheafOfModules.IsFiniteType`
  as `\texttt{}` prose mentions rather than first-class DAG nodes. If you want the
  route's Mathlib reliance to resolve as DAG nodes (effort = done rather than only
  visible in prose), consider a follow-up directive naming these four as anchors —
  all four were verified to exist this session.
- **`thm:generic_flatness` re-sign is still pending and is a `.lean` edit** (out of my
  write-domain). The blueprint now specifies the faithful target
  (`[F.IsQuasicoherent]` + `[F.IsFiniteType]`); the actual signature change in
  `AlgebraicJacobian/Picard/FlatteningStratification.lean` line 178 is the next
  scaffold/refactor pass as the directive notes.
- **Stray `\leanok` inside `thm:generic_flatness`.** There is a `\leanok` between
  `\begin{theorem}` and the `[Generic flatness, geometric form]` optional argument
  (chapter line ~107). I did not touch it (directive: do not add/remove `\leanok`),
  but it is oddly placed and sits on a theorem whose `sorry` is currently unprovable.
  `sync_leanok` should reconcile it once the signature is corrected; flagging for
  awareness.
- **`thm:generic_flatness_algebraic` remains `unmatched_lean`** in `leandag`
  (`AlgebraicGeometry.TODO.genericFlatnessAlgebraic` has no real Lean decl). This is
  intentional per the directive (keep the `TODO.` pin); not an error introduced here.

## Strategy-modifying findings
None. The restructuring is consistent with the existing strategy: the algebraic core
becomes a thin Mathlib wrapper plus a precisely-stated polynomial-ring residue, and the
geometric form's faithful (coherence-carrying) target is now specified in prose. No
claim in the chapter was found to be unprovable-as-needed or to contradict its use
elsewhere.
