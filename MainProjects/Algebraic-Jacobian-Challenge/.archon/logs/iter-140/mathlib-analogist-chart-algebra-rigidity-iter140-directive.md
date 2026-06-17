# mathlib-analogist directive — iter-140 — chart-algebra rigidity alternative for (i.b)+(i.c)

You are the iter-140 mathlib-analogist for the **direct chart-algebra
rigidity alternative** to the bundled (i.b)+(i.c) shear-iso-globalisation
+ chart-localisation route. Scheduled per `strategy-critic-iter139`
Must-fix #4 (recorded for iter-140 dispatch in iter-139 plan agent's
acknowledgments) and per the iter-140 watch criterion #3 in iter-139
PROGRESS.md.

Produce the persistent file
`analogies/direct-chart-algebra-rigidity-ib-ic.md`
in addition to the standard `task_results/<your-name>-<slug>.md` report.

## Question

The current (i.b)+(i.c) build path uses:
- **(i.b)** `mulRight_globalises_cotangent`: globalise the chart-base-changed
  `cotangentSpaceAtIdentity G` (from iter-128→iter-132 piece (i.a)) to
  `Ω_{G/k}` ≅ `pr_1^* (η_G^* Ω_{G/k})` via the shear iso applied at the
  presheaf-of-modules level.
- **(i.c.1)** chart-localisation identification of `relativeDifferentialsPresheaf`
  pulled back along `η_G` with the chart-base-changed `cotangentSpaceAtIdentity G`.
- **(i.c.2)** `omega_free` (freeness of `Ω_{G/k}` as `O_G`-module).
- **(i.c.3)** `omega_rank_eq_dim` (rank pinning).

Total envelope per current STRATEGY.md: ~410–810 LOC for (i.b) + ~200–500 LOC for (i.c) = ~610–1310 LOC.

**Alternative**: directly attack rigidity ON CHARTS, without globalising the cotangent. Concretely:
- For a morphism `f : C → A` (smooth proper geom-irr curve C / smooth proper geom-irr group scheme A over k with `df = 0` on charts):
- Restrict `f^#` to each affine chart `V ⊆ A.left` (where `V/k` is standard-smooth of dim `n`).
- Use the freeness of `Ω_{V/k}` as a `Γ(V)`-module (from `Algebra.IsStandardSmooth`) directly, without lifting to a globalised `Ω_{A/k}`.
- Glue via `Scheme.Over.ext_of_eqOnOpen` (already in-tree iter-125).

The bypassed targets would be `mulRight_globalises_cotangent`, `omega_free`, and possibly `omega_rank_eq_dim` (they may still be useful but not load-bearing for the rigidity argument).

## What to investigate

1. **Mathlib infrastructure**: does Mathlib `b80f227` have the ring-side ingredients to make chart-level rigidity work?
   - `Algebra.IsStandardSmooth.finite_kaehlerDifferential` or equivalent (freeness of `Ω_{B/A}` for standard-smooth `A → B`).
   - `KaehlerDifferential.exact_mapBaseChange_map` family for chart-level reductions.
   - Ring-level "df = 0 ⇒ f factors through k" (this is `Differential.ContainConstants`-shaped, but recall the iter-138 `containConstants-iter138` verdict: PIN-path-(b) direct `KaehlerDifferential.D` route — see `analogies/differential-containConstants-alignment.md`).
2. **LOC comparison**: estimate the chart-algebra rigidity total LOC against the bundled (i.b)+(i.c) 610–1310 LOC, including:
   - Cost of building the chart-level "df = 0" lemma directly.
   - Cost of the `Scheme.Over.ext_of_eqOnOpen` glue.
   - Cost of NOT having `omega_free` / `omega_rank_eq_dim` available for any future consumer (downstream API impact).
3. **Compatibility with piece (ii)**: piece (ii) `Scheme.Over.ext_of_diff_zero` is the **direct `KaehlerDifferential.D` route** per iter-138 `mathlib-analogist-containConstants-iter138`. Does the chart-algebra rigidity alternative essentially RE-USE piece (ii)'s machinery for the rigidity argument, making the bundled (i.b)+(i.c) build redundant?
4. **Compatibility with piece (iii)**: piece (iii) char-p Frobenius iteration uses absolute Frobenius `F_X` (iter-126 + iter-127 analogists). Does chart-algebra rigidity compose with piece (iii) on charts (ring-level Frobenius `Mathlib.Algebra.CharP.Frobenius`) without needing the scheme-level absolute Frobenius PHANTOM (800–1500 LOC)?
5. **API value of the bundled targets**: `omega_free` + `omega_rank_eq_dim` are independently useful as named Mathlib-shaped consequences. If chart-algebra rigidity bypasses them, is the project losing material that an external Mathlib-PR consumer would want?

## Verdict shape

Return one of:
- **ALIGN_WITH_BUNDLED**: stay on (i.b)+(i.c) as currently scoped. Cite the cost differential and downstream-API arguments.
- **PIVOT_TO_CHART_ALGEBRA**: drop (i.b) + (most of) (i.c); rework piece (ii) to cover the chart-rigidity argument; LOC savings X; piece (iii) implications Y; downstream-API cost Z.
- **HYBRID**: keep (i.b) for `Ω_{G/k}` freeness; drop the (i.c) chart-localisation identification if chart-algebra rigidity bypasses it.
- **NEEDS_MATHLIB_GAP_FILL**: chart-algebra rigidity requires a Mathlib piece that isn't in `b80f227` (name it; estimate LOC).

State LOC savings/cost ranges, dependencies, and a concrete iter-140+ schedule recommendation.

## Context the planner can give you (these files are safe to read)

- `analogies/cotangent-vanishing-pile-over-k.md` (iter-127 OK_OVER_K verdict on whole pile).
- `analogies/mulright-globalises-cotangent.md` (iter-133 sheaf-level RHS verdict for (i.b)).
- `analogies/kaehler-tensorequiv-presheafpullback.md` (iter-137 universal-property recipe).
- `analogies/isiso-basechange-along-proj-two-inv.md` (iter-139 Route (b'2) verdict).
- `analogies/differential-containConstants-alignment.md` (iter-138 PIN-path-(b) for piece (ii)).
- `analogies/serre-duality.md` (named-gap status for piece (iv)).
- The current Lean state of `AlgebraicJacobian/Cotangent/GrpObj.lean` (esp. L432–L625 for iter-138 helpers, and L72–L240 for iter-132 piece (i.a) closure).
- `blueprint/src/chapters/RigidityKbar.tex` § Piece (i) (only as a structured prose pointer).
- `references/challenge.lean` for the protected signatures (esp. `nonempty_jacobianWitness` and `rigidity_over_kbar`/`rigidity_over_k`).

## Output

Persistent file `analogies/direct-chart-algebra-rigidity-ib-ic.md` documenting the analysis (so iter-141+ planners can read it without re-asking) + standard report at `task_results/<your-name>-<slug>.md`.
