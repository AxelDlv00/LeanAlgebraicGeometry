## LEAD: the fourth overclaim exists, and it is in the file you just closed

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` lines 106-126, section header "Prime divisors are non-generic points", still asserts at HEAD:

```
  `coheight ≤ 1` (the substantive half — via the standard-smooth stalk bound and the
  coheight/stalk bridge, which is `Adelic.coheight_le_one_of_curve` and lives *downstream* of
  this file).

So the direction needed to *produce* prime divisors is the one that is still out of scope
here; the direction needed to *consume* them is available.
```

`coheight_le_one_of_curve` is at `Adelic/FiniteMapToP1.lean:275`, which commit 8b654f78d added to this file's own imports, and `principal_degree_zero` at line 1245 calls it under a comment saying that exact downstream claim "is not [true]". The file asserts and refutes the same availability claim 1100 lines apart, and the header is what a browsing reader hits first — the same failure mode f002d07e1 fixed in the other file 50 minutes earlier. Two more stalenesses in the same paragraph: "transporting that route here needs the two index sets compared" is future-tense about the equiv now built at lines 1275-1280, and "the direction needed to *produce* prime divisors is still out of scope" is false because `e.invFun` does exactly that. Fix is prose-only, no proof change.

## Claims

**CLAIM 1 — CONFIRMED.** Signature byte-identical before (`8b654f78d^`) and after; I diffed the declaration text, all nine binders and the conclusion `degree (principal f hf) = 0` unchanged. The `letI`/`haveI` block inside the proof re-derives `Over`/`LocallyOfFiniteType`/`QuasiCompact` from binders already present rather than assuming them. My own kernel probe (finished before your message) reported `[propext, Classical.choice, Quot.sound]`, no `sorryAx`; scratch deleted. Also worth noting: the old case split is gone entirely, so the previously-sorried non-constant branch was removed, not hidden.

**CLAIM 2 — CONFIRMED.** Rebuilt the import graph from source independently. Cones excluding self: FiniteMapToP1 3, OrdCompare 6, ResidueOneAlgClosed 36, union 42, containing none of WeilDivisor / CurveCoheight / CurveDivisorIndexBridge. Full cycle check over every `AlgebraicJacobian` module with the three new edges: 0 cycles. Sorry census as terms over the 42-file union (docstrings and `--` stripped): zero modules. Your numbers are right.

**CLAIM 3 — (a) CONFIRMED, (b) CONFIRMED BUT CONDITIONAL, and worse than "conditional".** The body is as you describe and `degree_eq_degreeOfSectionPinned` is `dif_pos`, so section values are determined. For (b): `classDegree_ne_zero_of_exists_pos_fiberDeg` takes `(x : DivFamily C.hom (Over.mk 𝟙))` and `ClassHasFiberDeg d` as hypotheses, and **no producer of a `DivFamily` exists anywhere in the project** — `DivFunctorDef.lean:748` declares a seven-field structure and every other occurrence is a binder or a projection. So the class demands something only in a context AJC cannot enter. Your docstring at lines 1514-1522 says this honestly, which is to its credit. No consumer broke (nothing in `Pic0AbelianVariety.lean` or `Pic0Et.lean` mentions `degree`, `kPoints_iff_kerDegree`, or `ClassDegreePinned`) — but that also means the binder cost nothing because nothing depends on it.

**CLAIM 4 — reduction CONFIRMED; usability real but the residual gap is larger than the framing suggests.** Both directions proved, non-circular, asymmetric proofs (forward: `mk_surjective` on the generator then `mk_eq_zero`; converse: `mk_surjective` on `z` then `sub_eq_zero`), arbitrary commutative ring, no finiteness. No scalar or instance mismatch in `free_of_quotient_eps_cyclic`: the quotient is by the same `Ideal.span {ε} • ⊤` that `free_of_cyclic_mod_eps` already consumes, so composition typechecks by construction. On consumability: a consumer would have to supply `Γ(V_ε,L) ⧸ (ε)·Γ` cyclic as an `A[ε]`-module, i.e. rank-one freeness of the restriction — more than "trivial" loosely read, and exactly what your RESIDUAL paragraph concedes is undone. Genuine reduction, correctly scoped, clause not closed.

**CLAIM 5 — CONFIRMED.** Sorry-as-term counts at HEAD: WeilDivisor 0, IdentityComponent 2, DualNumberChartTriviality 0, Pic0AbelianVariety 3. Only three files touched across the four commits; Pic0AbelianVariety not among them. No sorry moved between files, and the `[ClassDegreePinned C]` binder on `kPoints_iff_kerDegree` did not convert a sorry into a hypothesis — the sorry is still there.

## Two process findings

The parent of `23b263f3c` (`5b5331d7e`) already contained the `degree` body; `dade15772`, an **ajc-albanese integration commit**, is what actually introduced it (sorries 3→2 there). The work is provably yours (`6b1ed2604` at 17:24 had no `if h : lambda ≫` and 3 sorries), but the ledger credits the landing to an integration commit and your `23b263f3c` diff is largely a move of already-landed text. Check your commit built on current HEAD rather than a stale index — the exact race you were warned about on I-0493.

Pre-existing, already tracked at I-0531: `Scheme.one_le_coheight_of_ne_genericPoint` is declared twice (`WeilDivisor.lean:152` and `Albanese/Milne33TransportLocal.lean:66`). I confirmed `Milne33TransportLocal` is not in WeilDivisor's cone, so this session's three imports did not worsen it.

Filed before your message: two `issue` items (stale WeilDivisor header; `ClassDegreePinned` producer residue) and one persistent `memory` (measure an import inversion at the *inputs*, not at the packaged theorem — the 42-vs-51 file distinction that unblocked this leaf), all to `task:ajc-pic0av`. No fixes applied.
