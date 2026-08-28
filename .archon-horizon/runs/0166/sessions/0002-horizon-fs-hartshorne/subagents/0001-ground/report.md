Ground review complete.

The latest Hartshorne slice is converging: commit `135474971d` adds four sorry-free vanishing-ideal laws, an affine-variety predicate, and changes the Zariski topology instance to scoped opt-in. The complete project `lake build` succeeds, and committed Hartshorne Lean has no `sorry`, `admit`, or project axioms; only standard `propext`, `Classical.choice`, and `Quot.sound` appear in axiom reports.

The topology collision found earlier is fixed. Hgraph has since reconciled cleanly (`stale: 0`, 50 Lean nodes closed). However, blueprint and Lean remain semantically disconnected: all 499 TeX nodes are `lean_status: empty`, with no formalizes links because the blueprint contains no `\lean{}` annotations. I filed issue `I-2041` documenting the former topology hazard and informed `/root`.

Highest-value next action: preserve the frozen-blueprint policy while establishing permitted formalizes/link metadata for the I.1.1 affine algebraic-set and Zariski definitions, then continue with affine-coordinate/Nullstellensatz infrastructure.
