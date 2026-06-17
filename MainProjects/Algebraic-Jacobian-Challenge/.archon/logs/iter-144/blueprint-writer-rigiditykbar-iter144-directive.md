# Blueprint Writer Directive

## Slug
rigiditykbar-iter144

## Target chapter
blueprint/src/chapters/RigidityKbar.tex

## Strategy context

Two iter-144 events drive this writer pass:

### (1) Iter-143 PARTIAL on piece (i.b) Step 2 d_app + iter-143 Wave 2 IsIso refactor

Iter-143 prover lane on piece (i.b) Step 2 d_app returned PARTIAL.
The iter-143 1-LOC `have hw : (fst G G).left ≫ G.hom = (snd G G).left ≫
G.hom := by rw [(fst G G).w, (snd G G).w]` step 3.a categorical
equality landed empirically, but the chase from 3.a → 3.b
(`PresheafedSpace.comp_c_app` lift) → 3.c (`Adjunction.homEquiv_naturality_right_symm`
transpose) → 3.d (`ModuleCat.Derivation.d_map` discharge) is blocked
at the **`Pushforward.comp_eq` + `eqToHom` type-coercion** layer.
Specifically: identifying `pushforward (fst).left.base ∘ pushforward
G.hom.base` with `pushforward (G ⊗ G).hom.base` is up-to-`rfl` modulo
`hw` at the functor level (via `Pushforward.comp_eq` which is `rfl`),
but threading it through the adjunction-transpose step requires
explicit `eqToHom` rewrites that the iter-143 prover lane did not fit
inside its envelope.

Iter-143 Wave 2 refactor extracted the per-open IsIso obligation from
an inline `letI := ... (fun _ => sorry)` pattern in
`relativeDifferentialsPresheaf_basechange_along_proj_two` into a new
named theorem `AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_app_isIso`
in `Cotangent/GrpObj.lean:745–751` (body still `sorry`; iter-143 IsIso
refactor restores audit transparency per the iter-143 STRATEGY.md
Edit 1 sorry-must-be-named-declaration discipline). The blueprint
currently mentions this NEW theorem only in a `%`-commented NOTE at
`RigidityKbar.tex:1141` inside the proof of `lem:GrpObj_omega_basechange_proj`.

### (2) Iter-144 chart-algebra PIVOT (committed iter-144)

Per `mathlib-analogist-chart-algebra-iter144` verdict (persistent file
`analogies/chart-algebra-vs-bundled-iter144.md`): the iter-144 plan
agent committed to PIVOT TO CHART-ALGEBRA for iter-145+ M2.body-pile
trajectory. Key reframing implications for `RigidityKbar.tex`:

- Piece (i.b) Step 2 d_app + IsIso + Main are **DESCOPED from
  critical-path** iter-145+. The named declarations remain in-tree
  (sorry-bodied) as auditable record of the bundled route, but are
  NOT iter-145+ prover targets.
- Piece (i.c.1/2/3) (`omega_free` / `omega_rank_eq_dim`) — **DESCOPED**.
  Chart-algebra routes the freeness + rank facts through chart-level
  `Algebra.IsStandardSmooth.free_kaehlerDifferential` per-chart.
- Piece (ii) PIN-path-(b) — **INFLATED to ~600–1050 LOC** to absorb
  chart-algebra (α) `Algebra.IsPushout`-from-affine-product helper
  + (β) per-chart translation-invariance argument upstream.
- Piece (iii) scheme-level absolute Frobenius PHANTOM (~800–1500 LOC)
  — **DESCOPED**. Chart-algebra uses ring-level
  `RingHom.iterateFrobenius_comm` from `Mathlib.Algebra.CharP.Frobenius`
  per-chart.

## Required content

### Edit 1 (MUST-FIX from `blueprint-reviewer-iter144` + `lean-vs-blueprint-checker-cotangent-grpobj-review143` MAJOR): add first-class `\begin{lemma}` block for `basechange_along_proj_two_inv_app_isIso`

Add a `\begin{lemma}` block to `RigidityKbar.tex` ADJACENT TO
`\thm{lem:GrpObj_omega_basechange_proj_inv}` (which sits at L1454–1522
in the current file). The label and `\lean{...}` hint:

```latex
\begin{lemma}[basechange-along-proj-two-inv app isIso]
  \label{lem:GrpObj_basechange_along_proj_two_inv_app_isIso}
  \lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_app_isIso}
  \uses{lem:GrpObj_omega_basechange_proj_inv, lem:GrpObj_omega_basechange_proj}
  For every open $X \in (G \otimes G).\mathrm{left}$, the application
  $(\mathtt{basechange\_along\_proj\_two\_inv}\ G).\mathrm{app}\ X$ is
  an isomorphism of $\Gamma(G \otimes G,\ \mathtt{snd}^{-1} X)$-modules.
\end{lemma}
\begin{proof}
  \uses{...}
  Per Route (b'2) items 2--4, the per-open iso is constructed as the
  composition of:
  ...
\end{proof}
```

The proof sketch material already exists in `RigidityKbar.tex:1245–1320`
as `%`-commented prose (Route (b'2) items 2–4: the chart-level
`Algebra.IsPushout`-from-affine-product helper, the
`pullbackObjEquivTensor` chart-unfolding helper, and the per-open
identification with `tensorKaehlerEquiv.symm`). Extract that into the
new proof block. The new block should also note (per iter-144
chart-algebra pivot — see Edit 3 below): "Under the iter-144
chart-algebra pivot, this lemma is DESCOPED from critical-path;
preserved as an auditable record of the bundled route."

### Edit 2 (MUST-FIX from `blueprint-reviewer-iter144`): update Step 3 (3.a–3.d) sub-recipe with iter-143 empirical Rule-4

Current `RigidityKbar.tex:786–866` documents Step 3 sub-recipe but
lacks the iter-143 empirical lesson. Add a Rule-4-style block to the
iter-142 Rules 1–3 NOTE block (which currently sits near L713), or
to the Step 3 sub-recipe directly:

> **Rule 4 (iter-143 empirical lesson on `Pushforward.comp_eq` /
> `eqToHom` type-coercion).** The categorical identification of
> `pushforward (fst).left.base ∘ pushforward G.hom.base` with
> `pushforward (G ⊗ G).hom.base` modulo `hw` is up-to-`rfl` at the
> functor level (`Pushforward.comp_eq` is `rfl`), but applying this
> identification at a specific open `X` requires explicit `eqToHom`
> insertions. The bespoke nat-trans chase through
> `pullbackPushforwardAdjunction.homEquiv` must thread these `eqToHom`
> rewrites alongside `Adjunction.homEquiv_naturality_right_symm`. The
> iter-143 prover lane could not fit this into its envelope; under the
> iter-144 chart-algebra pivot the Step 3 chase is DESCOPED (preserved
> only as auditable record).

### Edit 3 (Iter-144 chart-algebra pivot reframing — DESCOPE prose for piece (i.b) Step 2 + piece (i.c) + piece (iii))

Add a **§ "Iter-144 chart-algebra pivot — disposition" NOTE block**
near the start of § "Piece (i)" (likely L65–80 area):

> **Iter-144 chart-algebra pivot — disposition (per
> `mathlib-analogist-chart-algebra-iter144` + STRATEGY.md
> Iter-144 chart-algebra pivot block).** Effective iter-145+, the
> M2.body-pile commits to the **chart-algebra route**. Under this
> commitment:
> - Piece (i.b) Step 2 d_app sub-sorry, IsIso theorem
>   `basechange_along_proj_two_inv_app_isIso`, and piece (i.b) Main
>   `mulRight_globalises_cotangent` are DESCOPED from critical-path.
>   Their named declarations remain in-tree (sorry-bodied) as auditable
>   record of the bundled route but are NOT iter-145+ prover targets.
> - Piece (i.c.1/i.c.2/i.c.3) (`omega_free` / `omega_rank_eq_dim`
>   assembly) is DESCOPED. Chart-algebra routes the freeness + rank
>   facts through chart-level
>   `Algebra.IsStandardSmooth.free_kaehlerDifferential` per-chart, not
>   through a global sheaf-of-modules construction.
> - Piece (iii) scheme-level absolute Frobenius PHANTOM is DESCOPED;
>   chart-algebra uses ring-level `RingHom.iterateFrobenius_comm` from
>   `Mathlib.Algebra.CharP.Frobenius` per-chart.
> - Piece (ii) is INFLATED to absorb the chart-algebra (α) and (β)
>   helpers upstream; see § "Piece (ii)" for the updated envelope.
>
> Piece (i.a) `cotangentSpaceAtIdentity` + `cotangentSpaceAtIdentity_finrank_eq`
> (closed iter-132) remain in-tree as standalone infrastructure;
> chart-algebra does NOT consume them but they are independently useful
> downstream (Lie-algebra dual, etc.).

If `RigidityKbar.tex` already has § "Piece (iii)" or § "Piece (i.c)"
subsections with prose targeting the bundled scheme-Frobenius / sheaf
constructions, add a one-line DESCOPED header to each.

### Edit 4 (Iter-144 chart-algebra pivot — INFLATE § "Piece (ii)" prose)

Find § "Piece (ii)" in `RigidityKbar.tex` (the section currently
documenting PIN-path-(b) via `KaehlerDifferential.D` direct, ~300–600
LOC envelope per the iter-138 alignment verdict). Re-cast the LOC
envelope and content per iter-144 chart-algebra pivot:

> **Iter-144 chart-algebra envelope (per
> `mathlib-analogist-chart-algebra-iter144`).** ~600–1050 LOC total,
> decomposed as:
> - Chart-algebra (α) `Algebra.IsPushout`-from-affine-product helper:
>   ~80–150 LOC. Constructs the `Algebra.IsPushout` instance on
>   `Γ(W, O_G) → Γ(V, O_{G ⊗ G})` for affine charts `V → W` in the
>   product. Built from `pullbackSpecIso` + `_hom_fst` / `_inv_fst` in
>   `Mathlib.AlgebraicGeometry.Pullbacks`.
> - Chart-algebra (β) per-chart translation-invariance Kähler-derivation
>   argument: ~150–300 LOC. The load-bearing core of M2.a's `df = 0`
>   derivation chain — see STRATEGY.md § Soundness rules "M2.a
>   `df = 0` derivation chain — articulated (added iter-144)" for the
>   three-layer prose.
> - Algebra-level core
>   `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`: ~200–350
>   LOC.
> - Integrally-closed-constants helper: ~50–100 LOC.
> - Scheme-level lift via `Scheme.Over.ext_of_eqOnOpen`: ~100–150 LOC.

The `df = 0` derivation chain (three layers — chart-local + char-p
Frobenius-iteration + no-Serre-duality) is described verbatim in
STRATEGY.md § Soundness rules; replicate it as a numbered list in the
piece (ii) prose so the iter-146+ prover lane has direct access to the
chain inside the chapter file.

### Edit 5 (Cleanup — refresh iter-138 status text + sync_leanok mis-mark soft-flag)

The blueprint reviewer flagged `RigidityKbar.tex:406, 524, 1152` as
sync_leanok mis-marks. These are out of agent scope — sync_leanok
manages `\leanok` deterministically. DO NOT touch these. Mention in
your report that they remain pending the deterministic sync_leanok
phase.

The chapter's piece-(i) prose contains iter-138 status-text fragments
(e.g. "iter-138 prover lane returned PARTIAL with Route (b) skeleton
landed; three sub-sorries remain"). Update to iter-143 status: d_map
closed iter-142 substantively (via 3-step ALIGN_WITH_MATHLIB chase per
`pushforward_obj_map_apply'` + `NatTrans.naturality_apply` +
`relativeDifferentials'_map_d`); d_app PARTIAL iter-143 (`have hw`
step 3.a landed, residual chase blocked at type-coercion); IsIso
extracted iter-143 to named theorem `basechange_along_proj_two_inv_app_isIso`
(see Edit 1). Reflect the chart-algebra DESCOPE per Edit 3.

## References

- `analogies/chart-algebra-vs-bundled-iter144.md` (iter-144 chart-algebra
  analogist's persistent file; full pivot design rationale).
- `analogies/direct-chart-algebra-rigidity-ib-ic.md` (iter-140 analogist
  on the chart-algebra alternative).
- `analogies/scheme-frobenius-piece-iii-scoping.md` (iter-141 analogist,
  superseded by iter-144 pivot but persistent for traceability).
- `analogies/d-app-d-map-recipe-shape.md` (iter-141 analogist on d_app
  + d_map recipes; the technique closing d_map iter-142 lives here).
- `analogies/isiso-basechange-along-proj-two-inv.md` (iter-139
  analogist on Route (b'2) IsIso closure).
- `analogies/differential-containConstants-alignment.md` (iter-138
  PIN-path-(b) verdict).

## Out of scope

- **DO NOT add or remove `\leanok` / `\mathlibok` markers anywhere.**
  Those are managed by the deterministic sync_leanok phase / review
  agent. Your edits add prose only.
- **DO NOT delete the bundled-route prose for piece (i.b) Step 2 +
  piece (i.c)**. The chart-algebra pivot DESCOPES these as critical-
  path but preserves them as auditable record; the existing prose at
  L786–866 (Step 3 sub-recipe), L1132–1320 (Route (b'2) IsIso
  sketch), L1454–1522 (`lem:GrpObj_omega_basechange_proj_inv` sketch)
  all stay; you ADD the chart-algebra DESCOPE NOTE around them but do
  not remove them.
- **DO NOT touch `Jacobian.tex` / `AbelJacobi.tex` / pointer chapters**.
  Those have their own writer dispatches.
- **DO NOT recompute LOC estimates yourself**; use the iter-144
  chart-algebra analogist's figures verbatim.
- **DO NOT propose strategy changes**. The iter-144 chart-algebra
  pivot is committed in STRATEGY.md; you reflect it in the chapter,
  you don't second-guess it.
