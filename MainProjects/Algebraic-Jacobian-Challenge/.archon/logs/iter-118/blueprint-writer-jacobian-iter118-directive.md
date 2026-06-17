# Blueprint Writer Directive

## Slug
jacobian-iter118

## Target chapter
`blueprint/src/chapters/Jacobian.tex`

## Strategy context

The project's `Jacobian.lean` file ships:

- `IsAlbanese` (universal-property predicate on a pointed curve,
  `def`) plus its data-extraction trio (`IsAlbanese.ofCurve`,
  `comp_ofCurve`, `exists_unique_ofCurve_comp`) and its uniqueness
  theorem (`IsAlbanese.unique`).
- `JacobianWitness` (structure bundling a smooth proper geometrically
  irreducible group scheme `J` plus an `isAlbaneseFor : ∀ P, IsAlbanese
  C P J` field — bundles the witness uniformly over the marked point).
- `nonempty_jacobianWitness` (load-bearing existence hypothesis,
  body `sorry`) — the single foundational sorry that the project
  ships against.
- `jacobianWitness := Classical.choice (nonempty_jacobianWitness C)`
  (extractor).
- `Jacobian C := (jacobianWitness C).J` (protected; main deliverable).
- Four protected instances on `Jacobian C` (group object, smooth of
  relative dimension `g`, proper, geometrically irreducible), each
  obtained by projecting the corresponding witness field.

The current blueprint chapter is mostly correct after the iter-117
rewrite. The iter-117 `lean-vs-blueprint-checker-jacobian-review117`
flagged **3 must-fix items** which this directive addresses.

## Required content

### Fix 1 — Tighten `thm:IsAlbanese_unique` statement-vs-prose

The current blueprint prose (chapter L38–44) says "any two Albanese
objects ... are **uniquely isomorphic by an isomorphism** compatible
with their universal morphisms," but the Lean signature `∃! (e : J₁
⟶ J₂), h₂.ofCurve = h₁.ofCurve ≫ e` claims only the existence of a
unique compatible *morphism*, not an isomorphism. The Lean proof
(L94–114) computes the isomorphism content (`hgh : g ≫ h = 𝟙 J₁`
L104, `hhg : h ≫ g = 𝟙 J₂` L113) but then returns `⟨g, hg_eq, ...⟩`,
discarding the invertibility witnesses.

The Lean signature for `IsAlbanese.unique` is NOT protected (verified
via `archon-protected.yaml`: the protected list contains
`Jacobian.ofCurve`, `Jacobian.comp_ofCurve`,
`Jacobian.exists_unique_ofCurve_comp` in `AbelJacobi.lean`, NOT the
`IsAlbanese.*` items in `Jacobian.lean`). The iter-118 plan agent has
TWO acceptable options:

**Option A (blueprint-side fix; preferred for this iter):** weaken
the blueprint prose to read "uniquely related by a compatible
morphism" (matching the current Lean). Add a separate remark
documenting that the proof internally computes the isomorphism
content, but this is not exposed in the returned tuple — and offer
a one-line note that the natural improvement is to return
`∃! (e : J₁ ≅ J₂), h₂.ofCurve = h₁.ofCurve ≫ e.hom`, which would
require the Lean side to refactor `IsAlbanese.unique`'s signature.

**Option B (defer to Lean-side refactor; NOT for this iter):**
tighten the Lean signature. This would require coordinating with
a refactor agent and re-proving the theorem; out of iter-118 scope.

Pick Option A for this iter: weaken the prose.

### Fix 2 — Add a `\structure` block for `JacobianWitness`

The `JacobianWitness` structure (Lean L143–160) is referenced
informally in `def:Jacobian` and `thm:nonempty_jacobianWitness`
but has no dedicated `\structure` (or `\definition`) block in the
chapter. Add one.

The block should describe the seven fields:

- `J : Over (Spec (.of k))` — the candidate Albanese object.
- `grpObj : GrpObj J` — the group-scheme structure on `J`.
- `proper : IsProper J.hom` — properness.
- `smooth : Smooth J.hom` — smoothness.
- `geomIrred : GeometricallyIrreducible J.hom` — geometric
  irreducibility.
- `smoothGenus : SmoothOfRelativeDimension (genus C) J.hom` —
  smooth of relative dimension `g(C)` (refines `smooth`; the
  redundancy is intentional, see Remark below).
- `isAlbaneseFor : ∀ (P : 𝟙_ _ ⟶ C), IsAlbanese C P J` — the
  Albanese universal property uniformly over choice of $k$-rational
  marked point.

Place this block at a natural location — probably between the
"Albanese universal property" and "Jacobian definition" sections,
or just before `thm:nonempty_jacobianWitness`. Use a `\definition`
environment (LaTeX `\begin{definition}...\end{definition}`) with
`\lean{AlgebraicGeometry.JacobianWitness}` and an appropriate
`\label`.

Add a short remark explaining the design choice of bundling
"$J$ once, plus the universal-property field $\forall P$" instead
of the prose-style "$\forall P, \exists J, \ldots$":

The classical statement is $\forall P, \exists J, J$ is an Albanese
object for $(C, P)$. The bundle reverses the quantifiers: a single
$J$ is chosen once (intrinsic to $C$), and the marked-point-dependent
data is the field `isAlbaneseFor`. Mathematically this is justified
because the underlying scheme of any Albanese object is intrinsic
to $C$ (different choices of $P$ yield $J$'s related by translation,
which is an automorphism of $J$); the bundle is what makes the
`AbelJacobi.lean` machinery's per-$P$ projection clean.

Optional: a one-line remark on the redundancy of `smooth` vs
`smoothGenus` (Mathlib has `SmoothOfRelativeDimension.smooth`
showing the second implies the first; keeping both is a Lean-level
convenience that does NOT cost soundness).

### Fix 3 — Add `\lean{...}` references for the `IsAlbanese.ofCurve`-extraction trio

Three Lean declarations are unreferenced in the chapter despite
feeding the protected `AbelJacobi.Jacobian.ofCurve` family:

- `AlgebraicGeometry.IsAlbanese.ofCurve` (Lean L67–70) — the
  universal pointed morphism extracted from an `IsAlbanese` term
  via `Classical.choose`.
- `AlgebraicGeometry.IsAlbanese.comp_ofCurve` (Lean L72–76) — the
  pointed-property field `P ≫ ofCurve = η[J]` extracted from
  `Classical.choose_spec`.
- `AlgebraicGeometry.IsAlbanese.exists_unique_ofCurve_comp` (Lean
  L78–84) — the universal-factorisation field.

Add a short subsection or remark titled "Extracting the universal
morphism" between the `IsAlbanese` definition block and the
uniqueness theorem block. State that an `IsAlbanese` term carries
data (the universal morphism) and properties (pointed property +
factorisation universality) which are projected by these three
helpers. Each helper gets a `\lean{...}` hint. The Lean implementation
uses `Classical.choose` / `Classical.choose_spec` on the existential
content of `IsAlbanese`.

This is the API consumed by `AbelJacobi.Jacobian.ofCurve` (and the
other two protected `Jacobian.{comp_ofCurve, exists_unique_ofCurve_comp}`
in `AbelJacobi.lean`) — currently the chapter mentions `\iota_P`
informally but doesn't pin the extraction API.

### Other items (informational, not must-fix)

- The proof block of `thm:nonempty_jacobianWitness` currently
  contains an in-proof `\leanok` marker (chapter L148). The Lean
  body is `:= sorry`, so the deterministic `sync_leanok` phase
  between prover and review should strip this marker. Verify this
  has been done after the next review phase; if `sync_leanok`
  leaves it, that's a `sync_leanok` issue, not a writer issue.
- `geometricallyIrreducible_id_Spec` (Lean L120–126) is defined
  but unused; this is a Lean-side cleanup candidate, not a blueprint
  issue.

## Out of scope

- Do NOT touch the `nonempty_jacobianWitness` proof block — the
  iter-117 expansion of the 3-route decomposition (Picard /
  Sym^g+Stein / genus-0 rigidity) is fine and is the project's
  honest disclosure of what's deferred.
- Do NOT touch other chapters.
- Do NOT modify the four protected-instance theorem blocks
  (`thm:Jacobian_grpObj`, `thm:Jacobian_smooth_genus`,
  `thm:Jacobian_proper`, `thm:Jacobian_geomIrred`) beyond cosmetic
  prose adjustments — their `\lean{...}` hints are pinned to
  protected names.
- Do NOT replace `\leanok` markers — that is `sync_leanok`'s
  domain.

## References

- `references/challenge.lean` — protected signatures.
- The iter-117 `lean-vs-blueprint-checker-jacobian-review117` report
  (archived at `.archon/logs/iter-117/lean-vs-blueprint-checker-jacobian-review117.md`)
  lists the 3 must-fix items verbatim with line numbers.

## Expected outcome

After your edit, the chapter:

1. Has a tightened `thm:IsAlbanese_unique` block whose prose matches
   the Lean signature ("unique compatible morphism", not
   "isomorphism") plus a one-paragraph remark documenting the
   internally-computed iso content and the natural Lean-side
   refactor candidate.
2. Contains a new `\definition`-style `\structure` block for
   `JacobianWitness` with all seven fields described, `\lean{...}`
   hint, and a brief design-choice remark.
3. Adds `\lean{...}`-tagged references for the
   `IsAlbanese.{ofCurve, comp_ofCurve, exists_unique_ofCurve_comp}`
   extraction trio.

No changes to the existing `nonempty_jacobianWitness` content or
the protected-instance theorem blocks.
